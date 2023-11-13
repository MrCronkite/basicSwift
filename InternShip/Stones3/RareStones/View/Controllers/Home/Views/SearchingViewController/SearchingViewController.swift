

import UIKit
import GoogleMobileAds
import NVActivityIndicatorView
import Moya
 
final class SearchingViewController: UIViewController {
    
    var alertController: UIAlertController?
    let networkStone = NetworkStoneImpl()
    var rocks: [Element] = []
    var filteredItems: [Element] = []
    let buttonViewAnimate = ButtonView()
    let provider = MoyaProvider<StoneProvider>()
    let loading = Loading()
    
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var noMathcLable: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var viewButtonAnimated: UIView!
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var textFiledSearch: UITextField!
    @IBOutlet weak var azButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var priceLowButton: UIButton!
    
    @IBOutlet weak var stoneColectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadAd()
        getAllStones()
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            bottomButtonConstraint.constant = 30
            boxAdView.isHidden = true
            stoneColectionView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)
        }
        
        AnalyticsManager.shared.logEvent(name: Events.open_all_stone)
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        azButton.backgroundColor = UIColor(hexString: "#dcdffd")
        priceButton.backgroundColor = UIColor(hexString: "#dcdffd")
        priceLowButton.backgroundColor = UIColor(hexString: "#dcdffd")
        azButton.tintColor = R.Colors.textColor
        priceButton.tintColor = R.Colors.textColor
        priceLowButton.tintColor = R.Colors.textColor
        switch sender.titleLabel?.text {
        case "h_search_low".localized:
            filteredItems.sort { Int($0.pricePerCaratTo?.remove$() ?? "0") ?? 0 < Int($1.pricePerCaratTo?.remove$() ?? "0") ?? 0 }
            stoneColectionView.reloadData()
        case "A - Z":
            filteredItems.sort { $0.name < $1.name }
            stoneColectionView.reloadData()
        case "h_search_high".localized:
            filteredItems.sort { Int($0.pricePerCaratTo?.remove$() ?? "0") ?? 0 > Int($1.pricePerCaratTo?.remove$() ?? "0") ?? 0}
            stoneColectionView.reloadData()
        case .none:
            return
        case .some(_):
            return
        }
        sender.backgroundColor = R.Colors.active
        sender.tintColor = .white
    }
    
    @IBAction func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func searchingText(_ sender: UITextField) {
        filterContentForSearchText(sender.text)
    }
}

extension SearchingViewController {
    private func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 8, y: 10, width: 16, height: 16)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textFiledSearch.frame.height))
        leftPaddingView.addSubview(iconImageView)
        textFiledSearch.leftView = leftPaddingView
        textFiledSearch.leftViewMode = .always
        textFiledSearch.layer.borderColor = UIColor.white.cgColor
        textFiledSearch.backgroundColor = UIColor(hexString: "#ede7fd")
        textFiledSearch.borderStyle = .none
        textFiledSearch.layer.cornerRadius = 10
        textFiledSearch.layer.borderWidth = 1
        textFiledSearch.tintColor = R.Colors.textColor
        textFiledSearch.textColor = R.Colors.textColor
        textFiledSearch.addDoneButtonOnKeyboard()
        textFiledSearch.autocorrectionType = .no
        
        let placeholderText = "Search by stones and minerals"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: R.Colors.textColor,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        textFiledSearch.attributedPlaceholder = attributedPlaceholder
        
        azButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        priceButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        priceLowButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        [azButton, priceButton, priceLowButton].forEach {
            $0?.backgroundColor = UIColor(hexString: "#dcdffd")
            $0?.layer.cornerRadius = 10
            $0?.tintColor = R.Colors.textColor
        }
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 44) / 2, height: 196)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 11
        layout.scrollDirection = .vertical
        
        stoneColectionView.isHidden = true
        stoneColectionView.showsVerticalScrollIndicator = false
        stoneColectionView.backgroundColor = .clear
        stoneColectionView.collectionViewLayout = layout
        stoneColectionView.contentInset = .init(top: 0, left: 0, bottom: 130, right: 0)
        stoneColectionView.dataSource = self
        stoneColectionView.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        viewButtonAnimated.layer.cornerRadius = 25
        viewButtonAnimated.backgroundColor = .clear
        buttonViewAnimate.delegate = self
        viewButtonAnimated.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        viewButtonAnimated.addSubview(buttonViewAnimate)
        viewButtonAnimated.layer.shadowColor = UIColor.black.cgColor
        viewButtonAnimated.layer.shadowOpacity = 0.3
        viewButtonAnimated.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewButtonAnimated.layer.shadowRadius = 10
        
        buttonClose.setTitle("", for: .normal)
        priceButton.setTitle("h_search_high".localized, for: .normal)
        priceLowButton.titleLabel?.textAlignment = .center
        priceButton.titleLabel?.textAlignment = .center
        priceLowButton.setTitle("h_search_low".localized, for: .normal)
        textFiledSearch.placeholder = "h_search_field".localized
        priceButton.isEnabled = false
        priceLowButton.isEnabled = false
        azButton.isEnabled = false
        textFiledSearch.isEnabled = false
        viewButtonAnimated.isHidden = true
        
        noMathcLable.text = "search_no_matching".localized
        noMathcLable.isHidden = true
    }
    
    private func loadAd() {
        let ad = GoogleAd.loadBaner()
        ad.rootViewController = self
        boxAdView.addBannerViewToView(ad)
    }
    
    func getAllStones() {
        loading.addLoading(view: self)
        provider.request(.getRocks(limit: 170)) { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(Rocks.self)
                    self.rocks = result.results
                    self.rocks.sort { $0.pricePerCaratFrom ?? "0" < $1.pricePerCaratFrom ?? "0" }
                    self.filteredItems = self.rocks
                    self.stoneColectionView.isHidden = false
                    self.priceButton.isEnabled = true
                    self.priceLowButton.isEnabled = true
                    self.azButton.isEnabled = true
                    self.textFiledSearch.isEnabled = true
                    self.viewButtonAnimated.isHidden = false
                    self.stoneColectionView.reloadData()
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_):
                LoadingIndicator.alertNoEthernet(view: self)
            }
        }
    }
    
    private func filterContentForSearchText(_ searchText: String?) {
        if let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
                let searchWords = searchText.components(separatedBy: " ")
                
                filteredItems = rocks.filter { item in
                    let lowercasedName = item.name.lowercased()
                    return searchWords.allSatisfy { searchWord in
                        return lowercasedName.contains(searchWord.lowercased())
                    }
                }
            } else {
                filteredItems = rocks
            }
            
            if filteredItems.isEmpty {
                noMathcLable.isHidden = false
            } else {
                noMathcLable.isHidden = true
            }
            
            stoneColectionView.reloadData()
    }
}

extension SearchingViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchingViewController: CartStoneDelegate {
    func setLoadIndicator() {
    }
    
    func checkInternet() {
        LoadingIndicator.alertNoEthernet(view: self)
    }
    
    func addToCollection() {
        self.getAllStones()
    }
    
    func deleteFromCollection() {
        self.getAllStones()
    }
    
    func openStone(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCollectionViewCell", for: indexPath) as! StoneCollectionViewCell
        cell.cellView.titleStone.text = filteredItems[indexPath.row].name
        cell.cellView.imageStone.setupImgURL(url: filteredItems[indexPath.row].image)
        cell.cellView.priceStone.text = "\(filteredItems[indexPath.row].pricePerCaratTo?.remove$() ?? "0") / ct"
        cell.cellView.id = filteredItems[indexPath.row].id
        cell.cellView.delegate = self
        cell.cellView.isButtonSelected = filteredItems[indexPath.row].isFavorite
        if filteredItems[indexPath.row].isFavorite {
            cell.cellView.btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
        } else { cell.cellView.btnHeart.setImage(UIImage(named: "heart"), for: .normal) }
        return cell
    }
}
