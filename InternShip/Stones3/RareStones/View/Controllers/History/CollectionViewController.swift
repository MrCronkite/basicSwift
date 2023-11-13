

import UIKit
import GoogleMobileAds
import NVActivityIndicatorView

final class CollectionViewController: UIViewController {
    
    var alertController: UIAlertController?
    let networkStone = NetworkStoneImpl()
    let networkClass = NetworkClassificationImpl()
    var isHistory = false
    var stonesWishList: [WishlistResult] = []
    var historyColletion: [HistoryResult] = []
    let btn = ButtonView()
    let loading = Loading()
    
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var openCatalogLable: UILabel!
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var boxBtnView: UIView!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var boxText: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var btncamera: UIView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var buttonSettings: UIButton!
    @IBOutlet weak var stonesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        loadAd()
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            bottomButtonConstraint.constant = 30
            boxAdView.isHidden = true
            stonesCollection.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0 )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        getStonesWhislist()
    }

    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isHistory {
            btnSecond.backgroundColor = .clear
            btnSecond.tintColor = R.Colors.textColor
            btnFirst.backgroundColor = R.Colors.roseBtn
            btnFirst.tintColor = .white
            btn.isHidden = false
        }
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func btnTogle(_ sender: UIButton) {
        btnFirst.backgroundColor = .clear
        btnFirst.tintColor = R.Colors.textColor
        btnSecond.backgroundColor = .clear
        btnSecond.tintColor = R.Colors.textColor
        
        sender.tintColor = .white
        sender.backgroundColor = R.Colors.roseBtn
        if sender.titleLabel?.text == "history_button".localized {
            getHistory()
            btn.isHidden = false
        } else {
            getStonesWhislist()
        }
    }
    
    @IBAction func openAllStones(_ sender: UITapGestureRecognizer) {
        let vc = SearchingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CollectionViewController {
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        boxBtnView.backgroundColor = UIColor(hexString: "#DAD1FB")
        boxBtnView.layer.cornerRadius = 30
        boxBtnView.layer.borderWidth = 1
        boxBtnView.layer.borderColor = UIColor.white.cgColor
        boxBtnView.clipsToBounds = true
        btnFirst.layer.cornerRadius = 26
        btnSecond.layer.cornerRadius = 26
        btnSecond.backgroundColor = .clear
        btnSecond.tintColor = R.Colors.textColor
        btnFirst.backgroundColor = R.Colors.roseBtn
        btnFirst.tintColor = .white
        btnFirst.makeAnimationButton(btnFirst)
        btnSecond.makeAnimationButton(btnSecond)
        btncamera.isHidden = true
        
        btncamera.layer.cornerRadius = 23
        btncamera.backgroundColor = R.Colors.roseBtn
        boxText.backgroundColor = .clear
        subtitle.greyColor()
        
        btn.delegate = self
        btncamera.frame = btn.frame
        btn.setupAnimation()
        btncamera.addSubview(btn)
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 44) / 2, height: 196)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 11
        layout.scrollDirection = .vertical
        stonesCollection.isHidden = true
        stonesCollection.showsVerticalScrollIndicator = false
        stonesCollection.backgroundColor = UIColor.clear
        stonesCollection.collectionViewLayout = layout
        stonesCollection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
        stonesCollection.dataSource = self
        stonesCollection.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        if stonesWishList.count > 0 {
            boxText.isHidden = true
        }
        
        btnFirst.addTarget(self, action: #selector(btnTogle(_:)), for: .touchUpInside)
        btnSecond.addTarget(self, action: #selector(btnTogle(_:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openAllStones(_:)))
        btncamera.addGestureRecognizer(tap)
        btncamera.isUserInteractionEnabled = true
    }
    
    private func loadAd() {
        let ad = GoogleAd.loadBaner()
        ad.rootViewController = self
        boxAdView.addBannerViewToView(ad)
    }
    
    private func getStonesWhislist() {
        btnFirst.isEnabled = false
        btnSecond.isEnabled = false
        loading.addLoading(view: self)
        AnalyticsManager.shared.logEvent(name: Events.request_history_view)
        networkStone.getWashList() { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.isHistory = false
                    self.btncamera.isHidden = false
                    self.btnFirst.isEnabled = true
                    self.btnSecond.isEnabled = true
                    if data.count > 0 {
                        AnalyticsManager.shared.logEvent(name: Events.open_wish_list)
                        self.btn.isHidden = false
                        self.stonesWishList = data.results
                        self.stonesCollection.isHidden = false
                        self.stonesCollection.reloadData()
                        self.titleTxt.text = ""
                        self.subtitle.text = ""
                    } else {
                        self.stonesWishList = []
                        self.titleTxt.text = "wishlist_title".localized
                        self.subtitle.text = "wishlist_subtitle".localized
                        self.btn.isHidden = true
                        self.stonesCollection.isHidden = false
                        self.stonesCollection.reloadData()
                    }
                }
            case .failure(_):
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                    DispatchQueue.main.async {
                        self.alertNoEthernet()
                    }
                }
            }
        }
    }
    
    func getHistory() {
        loading.addLoading(view: self)
        AnalyticsManager.shared.logEvent(name: Events.request_history_view)
        networkClass.getClassificationHistory { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.isHistory = true
                    if data.count > 0 {
                        AnalyticsManager.shared.logEvent(name: Events.open_history_view)
                        self.historyColletion = data.results
                        self.stonesCollection.isHidden = false
                        self.stonesCollection.reloadData()
                        self.titleTxt.text = ""
                        self.subtitle.text = ""
                    } else {
                        self.historyColletion = []
                        self.stonesCollection.isHidden = false
                        self.stonesCollection.reloadData()
                        self.titleTxt.text = "history_title".localized
                        self.subtitle.text = "history_subtitle".localized
                    }
                }
            case .failure(_):
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                    DispatchQueue.main.async {
                        self.alertNoEthernet()
                    }
                }
            }
        }
    }
    
    func alertNoEthernet() {
        let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "alert_cancel".localized, style: .default) { _ in
            alert.dismiss(animated: false)
            self.tabBarController?.selectedIndex = 0
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func localize() {
        buttonSettings.setTitle("", for: .normal)
        btnFirst.setTitle("history_wishlist_button".localized, for: .normal)
        btnSecond.setTitle("history_button".localized, for: .normal)
        openCatalogLable.text = "history_open_catalog".localized
    }
}

extension CollectionViewController: CartStoneDelegate {
    func setLoadIndicator() {
        loading.addLoading(view: self)
    }
    
    func checkInternet() {
        LoadingIndicator.alertNoEthernet(view: self)
    }
    
    func openStone(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteFromCollection() {
        getStonesWhislist()
    }
}

extension CollectionViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isHistory {
            return historyColletion.count
        } else {
            return stonesWishList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCollectionViewCell", for: indexPath) as! StoneCollectionViewCell
        cell.cellView.delegate = self
        if isHistory {
            cell.cellView.titleStone.text = historyColletion[indexPath.row].results[0].stone.name
            cell.cellView.btnHeart.isHidden = true
            cell.cellView.imageStone.setupImgURL(url: historyColletion[indexPath.row].image)
            cell.cellView.priceStone.text = "\(historyColletion[indexPath.row].results[0].stone.pricePerCaratTo?.remove$() ?? "0") / ct"
            cell.cellView.id = historyColletion[indexPath.row].results[0].stone.id
            return cell
        } else {
            cell.cellView.isButtonSelected = true
            cell.cellView.btnHeart.isHidden = false
            cell.cellView.btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
            cell.cellView.imageStone.setupImgURL(url: stonesWishList[indexPath.row].stone.image)
            cell.cellView.priceStone.text = "\(stonesWishList[indexPath.row].stone.pricePerCaratTo?.remove$() ?? "0") / ct"
            cell.cellView.titleStone.text = stonesWishList[indexPath.row].stone.name
            cell.cellView.id = stonesWishList[indexPath.row].stone.id
            return cell
        }
    }
}

