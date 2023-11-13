

import UIKit

final class GalleryViewController: UIViewController {
    
    var presenter: GalleryPresenter?
    var imageIndex = 0
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scroolView: UIScrollView!
    @IBOutlet weak var collectionViewCoins: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setupView()
        }
    }
    
    @IBAction func close() {
        presenter?.popToView()
    }
}

private extension GalleryViewController {
    func setupView() {
        view.backgroundColor = .white
        scroolView.contentSize = CGSize(width: scroolView.frame.size.width * CGFloat(presenter?.photos.count ?? 0), height: scroolView.frame.size.height)
        scroolView.delegate = self
        
        if let photos = presenter?.photos {
            for (index, photo) in photos.enumerated() {
                let imageView = UIImageView()
                imageView.frame = CGRect(x: scroolView.frame.size.width * CGFloat(index), y: 0, width: scroolView.frame.size.width, height: scroolView.frame.size.height)
                imageView.image(url: photo?.image ?? "")
                imageView.contentMode = .scaleAspectFit
                scroolView.addSubview(imageView)
            }
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 32, height: 72)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        collectionViewCoins.collectionViewLayout = layout
        collectionViewCoins.showsHorizontalScrollIndicator = false
        collectionViewCoins.backgroundColor = .clear
        collectionViewCoins.dataSource = self
        collectionViewCoins.delegate = self
        collectionViewCoins.register(GalleryCell.self, forCellWithReuseIdentifier: "\(GalleryCell.self)")
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionViewCoins.selectItem(at: firstIndexPath, animated: false, scrollPosition: .top)
        collectionView(collectionViewCoins, didSelectItemAt: firstIndexPath)
        
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.back.image, for: .normal)
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GalleryCell.self)", for: indexPath) as? GalleryCell else { return UICollectionViewCell() }
        cell.imageViewCoin.image(url: presenter?.photos[indexPath.row]?.image ?? "")
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell else { return }
        cell.isSelected = !cell.isSelected
        imageIndex = indexPath.row
        let xOffset = CGFloat(imageIndex) * scroolView.frame.size.width
        scroolView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
}

extension GalleryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
        imageIndex = currentPage
        
        let selectedIndexPath = IndexPath(item: imageIndex, section: 0)
        collectionViewCoins.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
    }
}

extension GalleryViewController: GalleryViewProtocol {
    
}
