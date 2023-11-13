

import UIKit
import GoogleMobileAds

final class ArticleViewController: UIViewController {
    
    var id = ""
    let networkArticle = NetworkArticlesImpl()
    var parts: [PartItm] = []
    var stones:  [RelatedStone] = []
    var multiplHeight = 0
    var adBannerView: GADBannerView!
    var heightCell: [CGFloat] = []
    let loading = Loading()
    
    @IBOutlet weak var scrollViewContainer: UIScrollView!
    @IBOutlet weak var mentionsLable: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleMentions: UILabel!
    @IBOutlet weak var bottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionArticle: UICollectionView!
    @IBOutlet weak var titleMainText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var boxAdView: UIView!
    @IBOutlet weak var collectionStones: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getArticleById()
        AnalyticsManager.shared.logEvent(name: Events.open_articles)
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            boxAdView.isHidden = true
            scrollViewContainer.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setupLayer()
    }
    
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ArticleViewController {
    private func setupView() {
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 25
        
        let layoutArticle = UICollectionViewFlowLayout()
        layoutArticle.scrollDirection = .vertical
        layoutArticle.minimumLineSpacing = 30
        
        collectionArticle.collectionViewLayout = layoutArticle
        collectionArticle.showsVerticalScrollIndicator = false
        collectionArticle.backgroundColor = .clear
        collectionArticle.dataSource = self
        collectionArticle.delegate = self
        collectionArticle.register(ArticleCellView.self, forCellWithReuseIdentifier: "\(ArticleCellView.self)")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 134, height: 157)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        collectionStones.showsHorizontalScrollIndicator = false
        collectionStones.backgroundColor = UIColor.clear
        collectionStones.collectionViewLayout = layout
        collectionStones.dataSource = self
        collectionStones.register(MatchCell.self, forCellWithReuseIdentifier: "MatchCell")
        
        adBannerView = GADBannerView(adSize: GADAdSizeBanner)
        boxAdView.addBannerViewToView(adBannerView)
        adBannerView.adUnitID = R.Strings.KeyAd.bannerAdKey
        adBannerView.rootViewController = self
        adBannerView.load(GADRequest())
        closeButton.setTitle("", for: .normal)
        mentionsLable.text = "h_article_mentions".localized
        scrollViewContainer.contentInset = .init(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    private func getArticleById() {
        loading.addLoading(view: self)
        networkArticle.getArticlesById(id: id) { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.parts = data.parts
                    self.stones = data.relatedStones
                    if self.stones.count == 0 {
                        self.bottomAnchor.constant = 10
                        self.titleMentions.isHidden = true
                        self.collectionStones.isHidden = true
                    }
                    self.titleMainText.text = data.title
                    self.imgView.setupImgURL(url: data.thumbnail)
                    self.collectionArticle.reloadData()
                    self.collectionStones.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.alertNoEthernet()
                }
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
        let headerHeight = CGFloat(28 * parts.count)
        let collectionHeight = totalCellHeights + headerHeight
        self.collectionHeight.constant = collectionHeight
    }
}

extension ArticleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionArticle: return parts.count
        case collectionStones: return stones.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionArticle :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ArticleCellView.self)", for: indexPath) as? ArticleCellView else { return UICollectionViewCell() }
            if parts[indexPath.row].image == nil && parts[indexPath.row].title != nil {
                cell.bottomLabelConstraint.constant = 0
                cell.imageViewArticle.isHidden = true
            } else if parts[indexPath.row].title == nil && parts[indexPath.row].image == nil {
                cell.imageViewArticle.isHidden = true
                cell.titleArticle.isHidden = true
                cell.bottomLabelConstraint.constant = 0
                cell.topLabelConstraint.constant = 0
            } else if parts[indexPath.row].title == nil {
                cell.titleArticle.isHidden = true
                cell.topLabelConstraint.constant = 0
            }
            cell.imageViewArticle.setupImgURL(url: parts[indexPath.row].image ?? "")
            cell.textArticel.text = parts[indexPath.row].text
            cell.titleArticle.text = parts[indexPath.row].title
            return cell
        case collectionStones :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MatchCell.self)", for: indexPath) as? MatchCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.imgView.setupImgURL(url: stones[indexPath.row].image ?? "")
            cell.titleTxt.text = stones[indexPath.row].name
            cell.id = stones[indexPath.row].id
            cell.priceTxt.text = ""
            return cell
        default: return UICollectionViewCell()
        }
    }
}

extension ArticleViewController: MatchCellDelegate {
    func showCart(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = parts[indexPath.row]
        let cellWidth = collectionView.frame.width
        
        if parts[indexPath.row].image == nil && parts[indexPath.row].title != nil {
            let height = ArticleCellView.calculateCellHeight(for: item.text, width: cellWidth) + 30
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)
            
        } else if parts[indexPath.row].title == nil && parts[indexPath.row].image == nil {
            let height = ArticleCellView.calculateCellHeight(for: item.text, width: cellWidth)
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)
            
        } else if parts[indexPath.row].title == nil {
            let height = ArticleCellView.calculateCellHeight(for: item.text, width: cellWidth) + 190
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)
            
        } else {
            let height = ArticleCellView.calculateCellHeight(for: item.text, width: cellWidth) + 220
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)
        }
    }
}
