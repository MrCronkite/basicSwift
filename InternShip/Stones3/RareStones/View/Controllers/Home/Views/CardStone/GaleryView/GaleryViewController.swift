

import UIKit

final class GaleryViewController: UIViewController {
    
    var photos: [PhotoId] = []
    
    var imageIndex = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var collectionImg: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        imgView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        imgView.addGestureRecognizer(swipeRight)
                
        imgView.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToRoot(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            imageIndex = (imageIndex + 1) % photos.count
        } else if sender.direction == .right {
            imageIndex = (imageIndex - 1 + photos.count) % photos.count
        }
        
        let selectedIndexPath = IndexPath(item: imageIndex, section: 0)
        collectionImg.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
        
        UIView.transition(with: imgView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imgView.setupImgURL(url: self.photos[self.imageIndex].image)
        }, completion: nil)
    }
}

extension GaleryViewController {
    private func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 22, height: 42)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        collectionImg.collectionViewLayout = layout
        collectionImg.showsHorizontalScrollIndicator = false
        collectionImg.backgroundColor = .clear
        collectionImg.dataSource = self
        collectionImg.delegate = self
        collectionImg.register(ImgCell.self, forCellWithReuseIdentifier: "\(ImgCell.self)")
        
        imgView.contentMode = .scaleAspectFill
        imgView.setupImgURL(url: photos[0].image)
        backButton.setTitle("", for: .normal)
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        collectionImg.selectItem(at: firstIndexPath, animated: false, scrollPosition: .top)
        collectionView(collectionImg, didSelectItemAt: firstIndexPath)
    }
}
 
extension GaleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImgCell.self)", for: indexPath) as? ImgCell else {
            return UICollectionViewCell()}
        cell.viewImgCell.setupImgURL(url: photos[indexPath.row].image)
        return cell
    }
}

extension GaleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imgView.setupImgURL(url: photos[indexPath.row].image)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImgCell else { return }
        cell.isSelected = !cell.isSelected
        imageIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImgCell else { return }
      //  cell.isSelected = cell.isSelected
    }
}
