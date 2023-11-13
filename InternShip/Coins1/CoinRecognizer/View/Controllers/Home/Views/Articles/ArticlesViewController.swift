

import UIKit
import GoogleMobileAds
import Kingfisher

final class ArticlesViewController: UIViewController {
    
    var presenter: ArticlesPresenter?
    private var heightCell: [CGFloat] = []
    
    @IBOutlet weak private var navBarTitle: UILabel!
    @IBOutlet weak private var mainTitle: UILabel!
    @IBOutlet weak private var mainImageView: UIImageView!
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var scrolViewArticle: UIScrollView!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var footerView: UIView!
    @IBOutlet weak private var adContainer: UIView!
    @IBOutlet weak private var collectionHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.loadBanner()
        presenter?.setupArticleForView()
    }
}

private extension ArticlesViewController {
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        navBar.setupStyleNavBar(title: "", style: .back)
        navBar.backgroundColor = UIColor.init(white: 1, alpha: 0)
        navBar.delegate = self
        mainImageView.contentMode = .scaleAspectFill
        scrolViewArticle.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        
        collectionView.collectionViewLayout = layout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CellArticleView.self, forCellWithReuseIdentifier: "\(CellArticleView.self)")
    }
    
    func calculateCollectionHeight() {
        let totalCellHeights = heightCell.reduce(0, +)
        let headerHeight = CGFloat(28 * (presenter?.article?.parts.count)!)
        let collectionHeight = totalCellHeights + headerHeight
        self.collectionHeight.constant = collectionHeight
    }
}

extension ArticlesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.article?.parts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CellArticleView.self)", for: indexPath) as? CellArticleView else { return UICollectionViewCell() }
        guard let parts = presenter?.article?.parts else { return UICollectionViewCell() }
        
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
        
        cell.titleArticle.text = parts[indexPath.row].title
        cell.textArticel.text = parts[indexPath.row].text
        cell.imageViewArticle.image(url: parts[indexPath.row].image ?? "")
        return cell
    }
}

extension ArticlesViewController: UICollectionViewDelegate {
}

extension ArticlesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let parts = presenter?.article?.parts else { return .zero }
        let item = parts[indexPath.row]
        let cellWidth = collectionView.frame.width
        
        if parts[indexPath.row].image == nil && parts[indexPath.row].title != nil {
            let height = CellArticleView.calculateCellHeight(for: item.text, width: cellWidth) + 30
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)

        } else if parts[indexPath.row].title == nil && parts[indexPath.row].image == nil {
            let height = CellArticleView.calculateCellHeight(for: item.text, width: cellWidth)
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)

        } else if parts[indexPath.row].title == nil {
            let height = CellArticleView.calculateCellHeight(for: item.text, width: cellWidth) + 190
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)

        } else {
            let height = CellArticleView.calculateCellHeight(for: item.text, width: cellWidth) + 220
            heightCell.append(height)
            if parts.count == heightCell.count { calculateCollectionHeight() }
            return CGSize(width: cellWidth, height: height)
        }
    }
}

extension ArticlesViewController: NavBarViewDelegate {
    func goBack() {
        presenter?.popToRoot()
    }
}

extension ArticlesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        let hideThreshold: CGFloat = 100.0
       
        let alpha = 1.0 - min(1.0, max(0.0, yOffset / hideThreshold))
        let reverseAlpha = 0.0 + max(0.0, min(1.0, yOffset / hideThreshold))
        
        UIView.animate(withDuration: 0.3) {
            self.mainImageView.alpha = alpha
            self.navBarTitle.alpha = reverseAlpha
        }
        
        if yOffset > 0 {
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = -44
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = -270
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ArticlesViewController: ArticlesViewProtocol {
    func succes() {
        mainImageView.image(url: presenter?.article?.thumbnail ?? "")
        mainTitle.text = presenter?.article?.title
        navBarTitle.text = presenter?.article?.title
        collectionView.reloadData()
    }
    
    func setupBanner(ad: GADBannerView) {
        ad.rootViewController = self
        adContainer.addBannerViewToView(ad)
        adContainer.isHidden = false
        footerView.isHidden = false
    }
}
 
