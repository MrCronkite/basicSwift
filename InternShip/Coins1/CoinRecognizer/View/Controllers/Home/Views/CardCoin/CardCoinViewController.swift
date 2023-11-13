

import UIKit
import Kingfisher

final class CardCoinViewController: UIViewController {
    
    var presenter: CardCoinPresenter?
    private var heightHeader: CGFloat = 0
    private var index = 0
    
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var foorImageView: UIImageView!
    @IBOutlet weak var containerImageView: UIView!
    
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var seeAllButton: UIButton!
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var mainScrollView: UIScrollView!
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var heightHeaderView: NSLayoutConstraint!
    @IBOutlet weak private var containerPhotos: UIView!
    @IBOutlet weak private var obverseImageView: UIImageView!
    @IBOutlet weak private var reverseImageView: UIImageView!
    @IBOutlet weak private var obverseMainImage: UIImageView!
    @IBOutlet weak private var reverseMainImage: UIImageView!
    @IBOutlet weak private var footerView: UIView!
    @IBOutlet weak private var addToCollectionButton: UIButton!
    @IBOutlet weak private var titleName: UILabel!
    @IBOutlet weak private var heartButton: UIButton!
    @IBOutlet weak private var collectionCoins: UICollectionView!
    @IBOutlet weak private var lableYears: UILabel!
    @IBOutlet weak private var lableYearsValue: UILabel!
    @IBOutlet weak private var lableMinatage: UILabel!
    @IBOutlet weak private var lableMintageValue: UILabel!
    @IBOutlet weak private var lableKrauseNUmber: UILabel!
    @IBOutlet weak private var lableKrauseNUmberValue: UILabel!
    @IBOutlet weak private var lableComposition: UILabel!
    @IBOutlet weak private var LableCompositionValue: UILabel!
    @IBOutlet weak private var containerReference: UIView!
    @IBOutlet weak private var titleReferencePrice: UILabel!
    @IBOutlet weak private var referencePriceValue: UILabel!
    @IBOutlet weak private var subtitleReference: UILabel!
    @IBOutlet weak private var titleDetermination: UILabel!
    @IBOutlet weak private var determinationView: UIView!
    @IBOutlet weak private var determinationValue: UILabel!
    @IBOutlet weak private var titleCountry: UILabel!
    
    @IBOutlet weak private var meltView: UIView!
    @IBOutlet weak private var titleMelt: UILabel!
    @IBOutlet weak private var meltValue: UILabel!
    @IBOutlet weak private var materialValue: UILabel!
    
    @IBOutlet weak private var titlePhysicalPropertis: UILabel!
    @IBOutlet weak private var coinLable: UIImageView!
    @IBOutlet weak private var weightLable: UILabel!
    @IBOutlet weak private var diamertLable: UILabel!
    @IBOutlet weak private var thicknessLable: UILabel!
    @IBOutlet weak private var edgeLable: UILabel!
    @IBOutlet weak private var weightValue: UILabel!
    @IBOutlet weak private var diametrValue: UILabel!
    @IBOutlet weak private var thicknessValue: UILabel!
    @IBOutlet weak private var edgeValue: UILabel!
    
    @IBOutlet weak private var titleLettering: UILabel!
    @IBOutlet weak private var obverseLable: UILabel!
    @IBOutlet weak private var obverseTextVAlue: UILabel!
    @IBOutlet weak private var reverseLable: UILabel!
    @IBOutlet weak private var reverseTextValue: UILabel!
    @IBOutlet weak private var titleMyCoins: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
        presenter?.showImages()
        presenter?.goToDataForView()
    }
    
    override func viewDidLayoutSubviews() {
        footerView.roundTopCorners(radius: 40)
    }
    
    @IBAction func goToFavorite(_ sender: UIButton) {
        let currenyImage = sender.currentImage
        if currenyImage == Asset.Assets.heart.image {
            heartButton.setImage(Asset.Assets.heartFill.image, for: .normal)
        } else {
            heartButton.setImage(Asset.Assets.heart.image, for: .normal)
        }
        
        sender.tapEffectReverse()
        presenter?.setupFavorite()
    }
    
    @IBAction private func addToCollection(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.addCollection()
    }
    
    @IBAction func seeAll(_ sender: Any) {
        presenter?.goToGallery()
    }
}

private extension CardCoinViewController {
    func setupView() {
        view.backgroundColor = Asset.Color.lightGray.color
        tabBarController?.tabBar.isHidden = true
        navBar.backgroundColor = Asset.Color.lightGray.color
        navBar.setupStyleNavBar(title: "", style: .back)
        navBar.delegate = self
        mainScrollView.delegate = self
        
        containerPhotos.backgroundColor = Asset.Color.dark.color
        containerPhotos.layer.cornerRadius = 16
        obverseImageView.layer.cornerRadius = 25
        obverseImageView.layer.borderWidth = 1
        obverseImageView.layer.borderColor = UIColor.white.cgColor
        reverseImageView.layer.cornerRadius = 25
        reverseImageView.layer.borderWidth = 1
        reverseImageView.layer.borderColor = UIColor.white.cgColor
        
        footerView.backgroundColor = .white
        addToCollectionButton.backgroundColor = Asset.Color.orange.color
        addToCollectionButton.layer.cornerRadius = 26
        addToCollectionButton.tintColor = .white
        
        heartButton.setTitle("", for: .normal)
        heartButton.setImage(Asset.Assets.heart.image, for: .normal)
        titleName.textColor = Asset.Color.dark.color
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 165, height: 90)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        collectionCoins.collectionViewLayout = layout
        collectionCoins.dataSource = self
        collectionCoins.backgroundColor = .white
        collectionCoins.contentInset = .init(top: 0, left: 16, bottom: 0, right: 0)
        collectionCoins.register(CoinsViewCell.self, forCellWithReuseIdentifier: "\(CoinsViewCell.self)")
        containerReference.layer.cornerRadius = 20
        containerReference.backgroundColor = Asset.Color.dark.color
        determinationView.layer.cornerRadius = 12
        meltView.layer.cornerRadius = 12
        coinLable.image = Asset.Assets.phiscoin.image
        reverseMainImage.layer.cornerRadius = 80
        obverseMainImage.layer.cornerRadius = 80
        
        heightHeader = heightHeaderView.constant
        
        firstImageView.layer.cornerRadius = 16
        firstImageView.layer.borderWidth = 1
        firstImageView.layer.borderColor = Asset.Color.textGray.color.cgColor
        
        secondImageView.layer.cornerRadius = 16
        secondImageView.layer.borderWidth = 1
        secondImageView.layer.borderColor = Asset.Color.textGray.color.cgColor
        
        thirdImageView.layer.cornerRadius = 16
        thirdImageView.layer.borderWidth = 1
        thirdImageView.layer.borderColor = Asset.Color.textGray.color.cgColor
        
        containerImageView.layer.cornerRadius = 16
        containerImageView.layer.borderWidth = 1
        containerImageView.layer.borderColor = Asset.Color.textGray.color.cgColor
        containerImageView.clipsToBounds = true
        
        seeAllButton.isEnabled = false
        seeAllButton.tintColor = .white
        seeAllButton.backgroundColor = Asset.Color.grey.color.withAlphaComponent(0.4)
    }
    
    func localize() {
        seeAllButton.setTitle("card_see_all".localized, for: .normal)
        addToCollectionButton.setTitle("add_to_collect".localized, for: .normal)
        lableYears.text = "yeard_of_minting".localized
        lableMinatage.text = "card_mintage".localized
        lableKrauseNUmber.text = "card_designer".localized
        lableComposition.text = "card_composition".localized
        titleReferencePrice.text = "card_referece".localized
        titleDetermination.text = "card_denomin".localized
        titleMelt.text = "card_melt".localized
        titlePhysicalPropertis.text = "card_physic".localized
        weightLable.text = "card_weight".localized
        diamertLable.text = "card_diameter".localized
        subtitleReference.text = "card_subtitle".localized
        thicknessLable.text = "card_thick".localized
        edgeLable.text = "card_edge".localized
        obverseLable.text = "card_obverse".localized
        reverseLable.text = "card_reverse".localized
        titleMyCoins.text = "card_my_coins".localized
        titleLettering.text = "card_lettering".localized
    }
}

extension CardCoinViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = presenter?.coins.first?.reference.userCollection?.userPhotos.count else { return 0 }
        return count / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CoinsViewCell.self)", for: indexPath) as? CoinsViewCell else { return UICollectionViewCell() }
        
        let startIndex = indexPath.row * 2
        let firstImageURL = presenter?.coins.first?.reference.userCollection?.userPhotos[startIndex]?.image ?? ""
        let secondImageURL = presenter?.coins.first?.reference.userCollection?.userPhotos[startIndex + 1]?.image ?? ""
        
        cell.obverseViewImage.image(url: firstImageURL)
        cell.reverseViewImage.image(url: secondImageURL)
        
        return cell
    }
}

extension CardCoinViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset > 0 {
            UIView.animate(withDuration: 0.7) {
                self.headerView.isHidden = true
                self.heightHeaderView.constant = 0
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.headerView.isHidden = false
                self.heightHeaderView.constant = self.heightHeader
                
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension CardCoinViewController: NavBarViewDelegate {
    func goBack() {
        presenter?.popToRoot()
    }
}

extension CardCoinViewController: CardCoinViewProtocol {
    func setupDataView() {
        titleName.text = presenter?.coins.first?.name
        lableYearsValue.text = presenter?.coins.first?.reference.dateRange.replacingCurrentYear()
        obverseMainImage.image(url: presenter?.coins.first?.reference.imageObverse ?? "")
        reverseMainImage.image(url: presenter?.coins.last?.reference.imageReverse ?? "")
        lableMintageValue.text = "\(presenter?.coins.first?.reference.mintage ?? 0)"
        LableCompositionValue.text = presenter?.coins.first?.reference.composition
        lableKrauseNUmberValue.text = presenter?.coins.first?.reference.designer
         
        let priceTo = presenter?.coins.first?.reference.priceTo ?? "0"
        let priceFrom = presenter?.coins.first?.reference.priceFrom ?? "0"
        
        titleCountry.text = presenter?.coins.first?.name.lastWordsAfterComma()
        determinationValue.text = presenter?.coins.first?.reference.denomination
        meltValue.text = presenter?.coins.first?.reference.designer
        referencePriceValue.text = "\(priceFrom) - \(priceTo)"
        weightValue.text = "\(presenter?.coins.first?.reference.weight ?? 41) g"
        diametrValue.text = "\(presenter?.coins.first?.reference.diameter ?? 37) mm"
        thicknessValue.text = "\(presenter?.coins.first?.reference.thickness ?? 2) mm"
        
        obverseTextVAlue.text = presenter?.coins.first?.reference.letteringObverse
        reverseTextValue.text = presenter?.coins.first?.reference.letteringReverse
        if presenter?.coins.first?.reference.isFavorite ?? false {
            heartButton.setImage(Asset.Assets.heartFill.image, for: .normal)
        }
        seeAllButton.isEnabled = true
        if presenter?.coins.first?.reference.photos.count != 0 {
            firstImageView.image(url: presenter?.coins.first?.reference.photos[0]?.image ?? "")
            secondImageView.image(url: presenter?.coins.first?.reference.photos[1]?.image ?? "")
            thirdImageView.image(url: presenter?.coins.first?.reference.photos[2]?.image ?? "")
            foorImageView.image(url: presenter?.coins.first?.reference.photos[3]?.image ?? "")
        }
        
        materialValue.text = presenter?.coins.first?.reference.composition
        meltValue.text = presenter?.coins.first?.reference.meltPrice ?? "$0"
        
        if presenter?.coins.first?.reference.userCollection  == nil {
            collectionCoins.isHidden = true
            bottomConstraint.constant = 150
            titleMyCoins.isHidden = true
        }
    }
    
    func setupImages(images: [UIImage]?) {
        if let images = images {
            containerPhotos.isHidden = false
            obverseImageView.image = images.first
            reverseImageView.image = images.last
        }
    }
}
