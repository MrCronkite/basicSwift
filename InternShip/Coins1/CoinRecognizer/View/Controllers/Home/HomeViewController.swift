

import UIKit
import GoogleMobileAds
import Kingfisher

final class HomeViewController: UIViewController {
    
    var presenter: HomePresenter?
    
    @IBOutlet weak private var premiumViewButton: UIView!
    @IBOutlet weak private var lableGoPremium: UILabel!
    @IBOutlet weak private var logoPremium: UIImageView!
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var imageViewRecognation: UIImageView!
    @IBOutlet weak private var containerViewRocognition: UIView!
    @IBOutlet weak private var subtitleRecognition: UILabel!
    @IBOutlet weak private var btnStartRecognition: UIButton!
    @IBOutlet weak private var textFieldSearch: UITextField!
    @IBOutlet weak private var cameraBtn: UIButton!
    @IBOutlet weak private var containerHelper: UIView!
    @IBOutlet weak private var containerCatalog: UIView!
    @IBOutlet weak private var titleAiHelper: UILabel!
    @IBOutlet weak private var titleCatalog: UILabel!
    @IBOutlet weak private var catalogLable: UIImageView!
    @IBOutlet weak private var titleInfo: UILabel!
    @IBOutlet weak private var helperLable: UIImageView!
    @IBOutlet weak private var collectionInfo: UICollectionView!
    @IBOutlet weak private var adContainer: UIView!
    @IBOutlet weak private var heightBannerConstraint: NSLayoutConstraint!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.loadArticles()
        setupTapGesture()
        localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
        DispatchQueue.main.async {
            self.presenter?.loadBanner()
            self.scrollView.contentInset.bottom = 60
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        cameraBtn.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction private func showCamera(_ sender: Any) {
        presenter?.tapOnTheCamera()
        cameraBtn.isHidden = true
    }
    
    @IBAction private func startRecognition(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.tapOnTheCamera()
        cameraBtn.isHidden = true
    }
    
    @objc private func handleTapOnCatalog() {
        containerCatalog.addTapEffect()
        presenter?.tapOnTheCatalog()
        cameraBtn.isHidden = true
    }
    
    @objc private func handleTapOnAiHelper() {
        containerHelper.addTapEffect()
        presenter?.tapOnTheChat()
        cameraBtn.isHidden = true
    }
    
    @objc private func goPremium() {
        presenter?.goToPremium()
    }
}

private extension HomeViewController {
    func setupView() {
        view.backgroundColor = .white
        tabBarController?.tabBar.items?[1].isEnabled = false
        navigationController?.navigationBar.isHidden = true
        cameraBtn.layer.cornerRadius = 40
        cameraBtn.setImage(Asset.Assets.cameraLogo.image, for: .normal)
        cameraBtn.backgroundColor = Asset.Color.orange.color
        cameraBtn.setTitle("", for: .normal)
        navBar.setupStyleNavBar(title: "", style: .nativ)
        navBar.delegate = self
        
        let iconImageView = UIImageView(image: Asset.Assets.searchText.image)
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textFieldSearch.frame.height))
        leftView.addSubview(iconImageView)
        
        textFieldSearch.leftView = leftView
        textFieldSearch.leftViewMode = .always
        textFieldSearch.backgroundColor = Asset.Color.lightBlue.color
        textFieldSearch.layer.cornerRadius = 10
        textFieldSearch.borderStyle = .none
        textFieldSearch.delegate = self
        
        containerHelper.backgroundColor = Asset.Color.mainBlue.color
        containerCatalog.backgroundColor = Asset.Color.mainBlue.color
        containerCatalog.layer.cornerRadius = 20
        containerHelper.layer.cornerRadius = 20
        titleCatalog.textColor = .black
        titleAiHelper.textColor = .black
        
        containerViewRocognition.backgroundColor = Asset.Color.original.color
        containerViewRocognition.layer.cornerRadius = 20
        btnStartRecognition.backgroundColor = .black
        btnStartRecognition.titleLabel?.textColor = .white
        btnStartRecognition.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btnStartRecognition.layer.cornerRadius = 25
        
        imageViewRecognation.image = Asset.Assets.homeCoins.image
        imageViewRecognation.contentMode = .scaleAspectFill
        subtitleRecognition.textColor = .black
        
        catalogLable.image = Asset.Assets.catalogCoins.image
        helperLable.image = Asset.Assets.messageCoin.image
        titleInfo.textColor = .black
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 41) / 2,  height: 109)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .vertical
        
        collectionInfo.layer.cornerRadius = 23
        collectionInfo.collectionViewLayout = layout
        collectionInfo.delegate = self
        collectionInfo.dataSource = self
        collectionInfo.backgroundColor = .clear
        collectionInfo.register(CollectionCellInfo.self, forCellWithReuseIdentifier: "\(CollectionCellInfo.self)")

        logoPremium.image = Asset.Assets.crown.image
        premiumViewButton.layer.cornerRadius = 25
        
        let tapGoToPremium = UITapGestureRecognizer(target: self, action: #selector(goPremium))
        premiumViewButton.isUserInteractionEnabled = true
        premiumViewButton.addGestureRecognizer(tapGoToPremium)
        
        let tabBarHeight = tabBarController?.tabBar.bounds.height
        bottomConstraint.constant = (tabBarHeight ?? 40) / 1.8
    }
    
    func setupTapGesture() {
        let tapGoToCatalog = UITapGestureRecognizer(target: self,
                                                    action: #selector(handleTapOnCatalog))
        containerCatalog.addGestureRecognizer(tapGoToCatalog)
        
        let tapGoToAiHelper = UITapGestureRecognizer(target: self,
                                                     action: #selector(handleTapOnAiHelper))
        containerHelper.addGestureRecognizer(tapGoToAiHelper)
    }
    
    func localize() {
        let placeholderText = "search".localized
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Asset.Color.textGray.color,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        textFieldSearch.attributedPlaceholder = attributedPlaceholder
        
        btnStartRecognition.setTitle("start_recogn".localized, for: .normal)
        titleAiHelper.text = "ai_helper".localized
        titleCatalog.text = "hom_catalog".localized
        subtitleRecognition.text = "home_sub".localized
        subtitleRecognition.adjustsFontSizeToFitWidth = true
        lableGoPremium.text = "home_get".localized
        titleInfo.text = "home_info_usef".localized
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionCellInfo.self)", for: indexPath) as? CollectionCellInfo else { return UICollectionViewCell() }
        cell.titleText.text = presenter?.articles[indexPath.row].title
        cell.mainImageView.image(url: (presenter?.articles[indexPath.row].thumbnail)!)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCellInfo {
            cell.tapEffectReverse()
            presenter?.tapOnTheArticles(id: indexPath.row)
            collectionInfo.isUserInteractionEnabled = false
        }
    }
}

//MARK: - TextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        presenter?.tapOnTheAllCoins()
    }
}

//MARK: - ViewProtocol
extension HomeViewController: HomeViewProtocol {
    func enableCollection() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.collectionInfo.isUserInteractionEnabled = true
        }
    }
    
    func enabledView() {
        collectionInfo.isUserInteractionEnabled = true
        cameraBtn.isHidden = true
    }
    
    func setupArticles() {
        collectionInfo.reloadData()
    }
    
    func setupBanner(ad: GADBannerView) {
        if premiumViewButton.isHidden {
            ad.rootViewController = self
            adContainer.addBannerViewToView(ad)
            heightBannerConstraint.constant = 50
            adContainer.isHidden  = false
            premiumViewButton.isHidden = false
        }
    }
    
    func deleteBaner() {
        heightBannerConstraint.constant = 0
        adContainer.isHidden  = true
        premiumViewButton.isHidden = true
    }
    
    func failure() {
        Activity.hide(view: view)
    }
}

extension HomeViewController: NavBarViewDelegate {
    func openWallet() {
        tabBarController?.selectedIndex = 2
    }
    
    func showSettings() {
        presenter?.tapOnTheSettings()
        cameraBtn.isHidden = true
    }
}


