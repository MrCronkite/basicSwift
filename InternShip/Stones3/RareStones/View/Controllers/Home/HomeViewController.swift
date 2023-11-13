

import UIKit
import Lottie
import GoogleMobileAds
import NVActivityIndicatorView

final class HomeViewController: UIViewController {
    
    var article: [Other] = []
    var articleAll: [Other] = []
    var originalArticle: [Other] = []
    var alertController: UIAlertController?
    let networkArticle = NetworkArticlesImpl()
    let buttonViewAnimate = ButtonView()
    var height: CGFloat = 0
    let loading = Loading()
    
    @IBOutlet weak var bottomBattonConstraint: NSLayoutConstraint!
    @IBOutlet weak var adBannerConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var originalCollection: UICollectionView!
    @IBOutlet weak var artLable: UILabel!
    @IBOutlet weak var btnTitle: UILabel!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var titleTextAll: UILabel!
    @IBOutlet weak var titleTextHealing: UILabel!
    @IBOutlet weak var uptoLable: UILabel!
    @IBOutlet weak var subtitlePremium: UILabel!
    @IBOutlet weak var titlePremium: UILabel!
    @IBOutlet weak var titleZodiac: UILabel!
    @IBOutlet weak var titleRare: UILabel!
    @IBOutlet weak var titleOriginal: UILabel!
    @IBOutlet weak var subtitleAll: UILabel!
    @IBOutlet weak var subtitleHealing: UILabel!
    @IBOutlet weak var subtitleZodiac: UILabel!
    @IBOutlet weak var subtitleRare: UILabel!
    @IBOutlet weak var viewHight: NSLayoutConstraint!
    @IBOutlet weak var tableHigh: NSLayoutConstraint!
    @IBOutlet weak var zodiacView: UIView!
    @IBOutlet weak var rareView: UIView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var healing: UIView!
    @IBOutlet weak var upToLable3: UILabel!
    @IBOutlet weak var upToLable2: UILabel!
    @IBOutlet weak var upToLable1: UILabel!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var rollUpBtn: UIButton!
    @IBOutlet weak var seeAllBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnalyticsManager.shared.logEvent(name: Events.open_home_view)
        setupLocaliz()
        setupView()
        loadAd()
        getArticlesPinned()
        
        TimerManager.shared.startTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("TimerTickNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roll()
        tabBarController?.tabBar.isHidden = false
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            adBannerConstraint.constant = 0
            boxAdView.isHidden = true
            height = 1200
            viewHight.constant = height
            topConstraint.constant = 10
            bannerView.isHidden = true
            bottomBattonConstraint.constant = 30
        } else {
            height = 1250
            viewHight.constant = height
        }
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
        zodiacView.setupGradient()
        rareView.setupGradient()
        allView.setupGradient()
        healing.setupGradient()
    }
    
    @IBAction func openAllStoneVC(_ sender: Any) {
        let vc = SearchingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func updateUI() {
        DispatchQueue.main.async {
            let remainingTime = TimerManager.shared.remainingTime
            let formattedTime = self.formatTimeInterval(remainingTime)
            self.timeTitle.text = formattedTime
            UIView.animate(withDuration: 0.6) {
                self.timeTitle.alpha = 1
            }
            if formattedTime == "00:00:00" {
                self.topConstraint.constant = 10
                self.bannerView.isHidden = true
                self.height -= 100
                self.viewHight.constant = self.height
                TimerManager.shared.stopTimer()
            }
        }
    }
    
    @IBAction func goPremium() {
        let vc = GetPremiumViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func goToZodiac(_ sender: UITapGestureRecognizer) {
        let vc = ZodiacViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToRare(_ sender: UITapGestureRecognizer) {
        AnalyticsManager.shared.logEvent(name: Events.open_home_view)
        let vc = RareStoneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToHealing(_ sender: UITapGestureRecognizer) {
        let vc = HealingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToAll(_ sender: UITapGestureRecognizer) {
        let vc = SearchingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seeAllTable(_ sender: Any) {
        rollUpBtn.isHidden = false
        seeAllBtn.isHidden = true
        tableHigh.constant = 1340
        article = articleAll
        articleTableView.reloadData()
        viewHight.constant = 1070 + height
    }
    
    @IBAction func rollUpTable(_ sender: Any) {
        roll()
    }
}

extension HomeViewController {
    private func setupView() {
        scrolView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.isHidden = true
        navBar.backgroundColor = R.Colors.purple
        btnView.layer.cornerRadius = 15
        btnView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hexString: "#DDCDFA").cgColor, UIColor(hexString: "#CEDBFD" ).cgColor, UIColor(hexString: "#FFFFFF").cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = btnView.bounds
        gradientLayer.zPosition = -1
        btnView.layer.addSublayer(gradientLayer)
        btnTitle.textColor = R.Colors.darkGrey
        
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 8, y: 8, width: 16, height: 16)
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: searchTextField.frame.height))
        leftPaddingView.addSubview(iconImageView)
        searchTextField.leftView = leftPaddingView
        searchTextField.leftViewMode = .always
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.backgroundColor = UIColor(hexString: "#ede7fd")
        searchTextField.borderStyle = .none
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 1
        searchTextField.tintColor = R.Colors.textColor
        searchTextField.textColor = R.Colors.textColor
        searchTextField.delegate = self
        searchTextField.placeholder = "h_search_field".localized
        timeTitle.alpha = 0
        
        bannerView.backgroundColor = UIColor(hexString: "#708fe7")
        bannerView.layer.cornerRadius = 25
        subtitleAll.greyColor()
        subtitleRare.greyColor()
        subtitleZodiac.greyColor()
        subtitleHealing.greyColor()
        artLable.textColor = R.Colors.darkGrey
        titleOriginal.textColor = R.Colors.darkGrey
        
        [titleTextAll, titleTextHealing, titleZodiac, titleRare].forEach { $0?.textColor = UIColor(hexString: "#4C4752") }
        
        [zodiacView, rareView, allView, healing].forEach {
            $0?.backgroundColor = R.Colors.whiteBlue
            $0?.layer.cornerRadius = 25
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.sendSubviewToBack($0!)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 170, height: 170)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumLineSpacing = 0
        
        originalCollection.contentInset.left = 16
        originalCollection.showsHorizontalScrollIndicator = false
        originalCollection.backgroundColor = UIColor.clear
        originalCollection.collectionViewLayout = layout
        
        originalCollection.dataSource = self
        originalCollection.delegate = self
        originalCollection.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        
        articleTableView.backgroundColor = .clear
        articleTableView.showsVerticalScrollIndicator = false
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.rowHeight = UITableView.noIntrinsicMetric
        articleTableView.separatorStyle = .none
        articleTableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
        tableHigh.constant = 270
        
        buttonViewAnimate.delegate = self
        viewBtn.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        viewBtn.addSubview(buttonViewAnimate)
        
        let tapZodiac = UITapGestureRecognizer(target: self, action: #selector(goToZodiac(_:)))
        zodiacView.addGestureRecognizer(tapZodiac)
        zodiacView.isUserInteractionEnabled = true
        
        let tapRare = UITapGestureRecognizer(target: self, action: #selector(goToRare(_:)))
        rareView.addGestureRecognizer(tapRare)
        rareView.isUserInteractionEnabled = true
        
        let tapHealing = UITapGestureRecognizer(target: self, action: #selector(goToHealing(_:)))
        healing.addGestureRecognizer(tapHealing)
        healing.isUserInteractionEnabled = true
        
        let tapAllStones = UITapGestureRecognizer(target: self, action: #selector(goToAll(_:)))
        allView.addGestureRecognizer(tapAllStones)
        allView.isUserInteractionEnabled = true
        
        let tapGetPremium = UITapGestureRecognizer(target: self, action: #selector(goPremium))
        btnTitle.addGestureRecognizer(tapGetPremium)
        btnTitle.isUserInteractionEnabled = true
    }
    
    private func loadAd() {
        let ad = GoogleAd.loadBaner()
        ad.rootViewController = self
        boxAdView.addBannerViewToView(ad)
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: interval) ?? "0:00:00"
    }
    
    private func getArticlesPinned() {
        if article.count == 0 {
            if LoadingIndicator.checkInthernet() {
                loading.removeBlockedView()
                tabBarController?.tabBar.isUserInteractionEnabled = true
                loading.blockerView(view: self)
                loading.addLoading(view: self)
                networkArticle.getArticlesStonesPinned { [weak self] result in
                    guard let self = self else { return }
                    loading.deleleLoader()
                    loading.removeBlockedView()
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.article = []
                            self.seeAllBtn.isHidden = false
                            self.rollUpBtn.isHidden = true
                            self.article.append(data.pinned[1])
                            self.article.append(data.pinned[0])
                            self.articleAll = data.pinned
                            self.articleTableView.reloadData()
                            self.originalArticle = data.other
                            self.originalCollection.reloadData()
                            self.loadAd()
                        }
                    case .failure(_): break
                    }
                }
            } else {
                loading.blockerView(view: self)
                tabBarController?.tabBar.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    LoadingIndicator.alert(title: "alert_no_internet".localized)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.getArticlesPinned()
                    }
                }
            }
        }
    }
    
    private func setupLocaliz() {
        searchTextField.text = "h_search_field".localized
        titlePremium.text = "h_lable_premium_title".localized
        titlePremium.adjustsFontSizeToFitWidth = true
        subtitlePremium.text = "h_lable_premium_subtitle".localized
        subtitlePremium.adjustsFontSizeToFitWidth = true
        btnTitle.text = "h_button_premium".localized
        titleTextAll.text = "h_title_stone_all".localized
        titleTextAll.adjustsFontSizeToFitWidth = true
        titleTextHealing.text = "h_title_stone_healing".localized
        titleTextHealing.adjustsFontSizeToFitWidth = true
        titleZodiac.text = "h_title_stone_zodiac".localized
        titleZodiac.adjustsFontSizeToFitWidth = true
        titleRare.text = "h_title_stone_rare".localized
        titleRare.adjustsFontSizeToFitWidth = true
        subtitleAll.text = "h_subtitle_all".localized
        subtitleHealing.text = "h_subtitle_healing".localized
        subtitleHealing.adjustsFontSizeToFitWidth = true
        subtitleZodiac.text = "h_subtitle_zodiac".localized
        subtitleZodiac.adjustsFontSizeToFitWidth = true
        subtitleRare.text = "h_subtitle_rare".localized
        artLable.text = "h_articles".localized
        titleOriginal.text = "h_original_vs_fake".localized
        uptoLable.text = "h_up_to".localized
        uptoLable.adjustsFontSizeToFitWidth = true
        upToLable1.text = "h_up_to".localized
        upToLable1.adjustsFontSizeToFitWidth = true
        upToLable2.text = "h_up_to".localized
        upToLable2.adjustsFontSizeToFitWidth = true
        upToLable3.text = "h_up_to".localized
        upToLable3.adjustsFontSizeToFitWidth = true
        seeAllBtn.setTitle("h_button_see".localized, for: .normal)
        seeAllBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        seeAllBtn.titleLabel?.textAlignment = .center
        rollUpBtn.setTitle("h_button_roll".localized, for: .normal)
    }
    
    func roll() {
        seeAllBtn.isHidden = false
        rollUpBtn.isHidden = true
        tableHigh.constant = 270
        articleTableView.isScrollEnabled = false
        articleTableView.reloadData()
        viewHight.constant = height
    }
}

extension HomeViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.titleText.text = article[indexPath.row].title
        cell.imageViewBase.setupImgURL(url: article[indexPath.row].thumbnail)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController()
        vc.id = String(article[indexPath.row].id)
        present(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        originalArticle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.cellView.lableText.text = originalArticle[indexPath.row].title
        cell.cellView.imageView.setupImgURL(url: originalArticle[indexPath.row].thumbnail)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ArticleStonesViewController()
        vc.id = String(originalArticle[indexPath.row].id)
        present(vc, animated: true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
