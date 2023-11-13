

import UIKit

final class SelectCollectionViewController: UIViewController {
    
    var presenter: SelectPresenter?
    
    @IBOutlet weak private var titleLable: UILabel!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var collectionFolders: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.loadCollection()
    }
    
    @IBAction private func close(_ sender: Any) {
        presenter?.closeView()
    }
}

private extension SelectCollectionViewController {
    func setupView() {
        view.backgroundColor = .white
        titleLable.text = "select_collect".localized
        
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(Asset.Assets.closeMiniGray.image, for: .normal)
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 43) / 2, height: 196)
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .vertical
        
        collectionFolders.collectionViewLayout = layout
        collectionFolders.backgroundColor = .clear
        collectionFolders.delegate = self
        collectionFolders.dataSource = self
        collectionFolders.register(CollectionCellFolder.self, forCellWithReuseIdentifier: "\(CollectionCellFolder.self)")
    }
}

extension SelectCollectionViewController: UICollectionViewDelegate {
    
}

extension SelectCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return presenter?.collections.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionCellFolder.self)", for: indexPath) as? CollectionCellFolder else { return UICollectionViewCell() }
        cell.imageViewFolder.image = presenter?.itemImages[indexPath.row]
        cell.setColorView(color: presenter?.itemColors[indexPath.row] ?? .black)
        cell.nameCollection.text = presenter?.collections[indexPath.row].name
        cell.nameCollection.textColor = presenter?.itemColors[indexPath.row]
        cell.setCollection()
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            cell.setFolder()
        }
        
        cell.buttonAddCollection = { self.presenter?.tapOnTheSetNameView() }
        cell.buttonOpenCollection = { self.presenter?.tapOnTheFolderView(index: indexPath.row) }
        
        return cell
    }
}

extension SelectCollectionViewController: SelectViewProtocol {
    func reloadData() {
        collectionFolders.reloadData()
    }
}

