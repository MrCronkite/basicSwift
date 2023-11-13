

import UIKit
import GoogleMobileAds

final class CatalogViewController: UIViewController {
    
    var presenter: CatalogPresenter?
    
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var textFieldSearch: UITextField!
    @IBOutlet weak private var collectionViewCotalog: UICollectionView!
    @IBOutlet weak private var footerView: UIView!
    @IBOutlet weak private var adContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.loadTags()
        presenter?.loadBanner()
    }
}

private extension CatalogViewController {
    func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navBar.setupStyleNavBar(title: "", style: .close)
        navBar.delegate = self
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 41) / 2, height: 163)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .vertical
        
        collectionViewCotalog.contentInset.bottom = 70
        collectionViewCotalog.collectionViewLayout = layout
        collectionViewCotalog.backgroundColor = .clear
        collectionViewCotalog.dataSource = self
        collectionViewCotalog.delegate = self
        collectionViewCotalog.register(CatalogViewCell.self, forCellWithReuseIdentifier: "\(CatalogViewCell.self)")
        
        let iconImageView = UIImageView(image: Asset.Assets.searchText.image)
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textFieldSearch.frame.height))
        leftView.addSubview(iconImageView)
        
        let placeholderText = "search".localized
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Asset.Color.textGray.color,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        textFieldSearch.attributedPlaceholder = attributedPlaceholder
        textFieldSearch.leftView = leftView
        textFieldSearch.leftViewMode = .always
        textFieldSearch.backgroundColor = Asset.Color.lightBlue.color
        textFieldSearch.layer.cornerRadius = 10
        textFieldSearch.borderStyle = .none
        textFieldSearch.delegate = self
    }
}

extension CatalogViewController: CatalogViewProtocol {
    func reloadView() {
        collectionViewCotalog.reloadData()
    }
    
    func setupBanner(ad: GADBannerView) {
        ad.rootViewController = self
        adContainer.addBannerViewToView(ad)
        footerView.isHidden = false
    }
}

extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.tags.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CatalogViewCell.self)", for: indexPath) as? CatalogViewCell else { return UICollectionViewCell() }
        cell.titleCatalog.text = presenter?.tags[indexPath.row].name
        cell.priceCoin.text = "\("home_up_to".localized) $200.000"
        cell.titleCatalog.textColor = presenter?.itemColors[indexPath.row]
        cell.backgroundColor = presenter?.itemImages[indexPath.row]
        return cell
    }
}

extension CatalogViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CatalogViewCell {
            cell.addTapEffect()
            presenter?.loadTag(by: indexPath.row)
        }
    }
}

extension CatalogViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        presenter?.tapOnAllCoins()
    }
}

extension CatalogViewController: NavBarViewDelegate {
    func close() {
        presenter?.tapOnClosse()
    }
}
