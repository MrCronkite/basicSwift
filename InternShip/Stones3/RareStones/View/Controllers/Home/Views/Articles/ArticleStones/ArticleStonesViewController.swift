

import UIKit
import GoogleMobileAds

final class ArticleStonesViewController: UIViewController {
    
    var alertController: UIAlertController?
    var id = "9"
    var partsCell: [PartItm] = []
    var partsText: [PartItm] = []
    let networkArticle = NetworkArticlesImpl()
    var expandedIndexPaths: Set<IndexPath> = []
    var heightCell: [CGFloat] = []
    let loading = Loading()
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleLable: UILabel!
    @IBOutlet weak var originalLable: UILabel!
    @IBOutlet weak var fakeLable: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var fakeImageView: UIImageView!
    @IBOutlet weak var boxFakeView: UIView!
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var collectionArticles: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var boxTxt: UIView!
    @IBOutlet weak var imgStone: UIImageView!
    @IBOutlet weak var articleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getArticleById()
        loadAd()
        
        AnalyticsManager.shared.logEvent(name: Events.open_articles)
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            boxAdView.isHidden = true
            bottomConstraint.constant = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
        collectionArticles.setupGradient()
    }
    
    @IBAction func closeVc(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ArticleStonesViewController {
    private func setupView() {
        bottomConstraint.constant = 85
        separator.layer.cornerRadius = 4
        imgStone.layer.cornerRadius = 16
        imgStone.contentMode = .scaleAspectFill
        imgStone.clipsToBounds = true
        boxTxt.layer.cornerRadius = 12
        boxFakeView.layer.cornerRadius = 12
        fakeImageView.layer.cornerRadius = 16
        fakeImageView.contentMode = .scaleAspectFill
        fakeImageView.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: Int(collectionArticles.frame.width) - 34, height: 226)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        
        collectionArticles.layer.cornerRadius = 25
        collectionArticles.layer.borderWidth = 1
        collectionArticles.layer.borderColor = UIColor.white.cgColor
        collectionArticles.collectionViewLayout = layout
        collectionArticles.delegate = self
        collectionArticles.dataSource = self
        collectionArticles.register(TipsStoneCell.self, forCellWithReuseIdentifier: "TipsStoneCell")
        
        buttonClose.setTitle("", for: .normal)
        originalLable.text = "h_article_orig".localized
        fakeLable.text = "h_article_fake".localized
        subtitleLable.text = "h_article_subtitle".localized
    }
    
    private func loadAd() {
        let ad = GoogleAd.loadBaner()
        ad.rootViewController = self
        boxAdView.addBannerViewToView(ad)
    }
    
    private func getArticleById() {
        loading.addLoading(view: self)
        networkArticle.getArticlesById(id: id) { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.titleText.text = data.title
                    self.imgStone.setupImgURL(url: data.thumbnail)
                    self.fakeImageView.setupImgURL(url: data.relatedStones[0].image ?? "")
                    data.parts.forEach {
                        if $0.title == nil {
                            self.partsText.append($0)
                        } else { self.partsCell.append($0) }
                    }
                    self.articleText.text = self.partsText[0].text
                    self.collectionArticles.reloadData()
                }
            case .failure(_):
                self.alertNoEthernet()
            }
        }
    }
    
    func alertNoEthernet() {
        let alert = UIAlertController(title: "alert_no_internet".localized, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "alert_cancel".localized, style: .default) { _ in
            alert.dismiss(animated: false)
            self.dismiss(animated: true)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func calculateCollectionHeight() {
        let totalCellHeights = heightCell.reduce(0, +)
        let headerHeight: CGFloat = 65
        let collectionHeight = totalCellHeights + headerHeight
        self.collectionHeight.constant = collectionHeight
    }
}

extension ArticleStonesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = partsCell[indexPath.row]
        let cellWidth = collectionView.frame.width - 32
        let height = TipsStoneCell.calculateCellHeight(for: item.text, width: cellWidth) + 50
        heightCell.append(height)
        if partsCell.count == heightCell.count { calculateCollectionHeight() }
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        partsCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipsStoneCell", for: indexPath) as? TipsStoneCell else { return UICollectionViewCell() }
        cell.indexCell = indexPath.row
        cell.text.text = partsCell[indexPath.row].text
        cell.titleCell.text = partsCell[indexPath.row].title
        return cell
    }
}

