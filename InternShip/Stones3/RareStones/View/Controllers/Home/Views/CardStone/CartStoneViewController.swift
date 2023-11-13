

import UIKit
import NVActivityIndicatorView

final class CartStoneViewController: UIViewController {
    
    var alertController: UIAlertController?
    var dataRock: RockID? = nil
    var titleDiscription: [String] = []
    var heightCell: [CGFloat] = []
    var article: [Other?] = []
    var id = 0
    let networkStone = NetworkStoneImpl()
    var expandedIndexPaths: Set<IndexPath> = []
    var isButtonSelected = false
    let loading = Loading()
    
    @IBOutlet weak var leadingRareConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHealingTag: UIView!
    @IBOutlet weak var containerRareTag: UIView!
    @IBOutlet weak var containerImageView: UIView!
    @IBOutlet weak var firstImageStone: UIImageView!
    @IBOutlet weak var secondImageStone: UIImageView!
    @IBOutlet weak var thirdImageStone: UIImageView!
    @IBOutlet weak var fortinImageStone: UIImageView!
    
    @IBOutlet weak var heightConstraintCart: NSLayoutConstraint!
    @IBOutlet weak var colorLable: UILabel!
    @IBOutlet weak var hardnessLable: UILabel!
    @IBOutlet weak var formulaLable: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var collectionDescription: UICollectionView!
    @IBOutlet weak var boxImg: UIView!
    @IBOutlet weak var stoneImgView: UIImageView!
    @IBOutlet weak var borderImg: UIView!
    @IBOutlet weak var nameStone: UILabel!
    @IBOutlet weak var costStone: UILabel!
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var btnSeeAll: UIButton!
    
    @IBOutlet weak var hardnesTxt: UILabel!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var formulaTxt: UILabel!
    @IBOutlet weak var colorTxt: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var healingTeg: UILabel!
    @IBOutlet weak var rareTeg: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        getDataStone()
        AnalyticsManager.shared.logEvent(name: Events.open_card_stone)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupLayer()
    }
    
    @IBAction func goToRoot(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openGallery(_ sender: Any) {
       gallery()
    }
    
    @objc func goGallery() {
        gallery()
    }
    
    @IBAction func saveStone(_ sender: UIButton) {
        if LoadingIndicator.checkInthernet(view: self) {
            isButtonSelected.toggle()
            let imageToSet = isButtonSelected ? UIImage(named: "fillheart") : UIImage(named: "heart")
            sender.setImage(imageToSet, for: .normal)
            loading.addLoading(view: self)
            let requestClosure: (Result<String, Error>) -> Void = { [weak self] result in
                guard let self = self else { return }
                self.loading.deleleLoader()
                switch result {
                case .success(_): break
                case .failure(_): break
                }
            }
            
            if id != 0 {
                if isButtonSelected {
                    networkStone.makePostRequestWashList(id: id, complition: requestClosure)
                } else {
                    networkStone.deleteStoneFromWishList(id: id, complition: requestClosure)
                }
            }
        }
    }
}

extension CartStoneViewController {
    private func setupView() {
        tabBarController?.tabBar.isHidden = true
        boxImg.layer.cornerRadius = 30
        boxImg.clipsToBounds = true
        stoneImgView.contentMode = .scaleAspectFill
        borderImg.backgroundColor = UIColor(hexString: "#708FE8").withAlphaComponent(0.7)
        btnHeart.layer.cornerRadius = 16
        colorTxt.adjustsFontSizeToFitWidth = true
        formulaTxt.adjustsFontSizeToFitWidth = true
        
        btnSeeAll.isEnabled = false
        btnSeeAll.layer.cornerRadius = 16
        btnSeeAll.backgroundColor = UIColor(hexString: "#708FE8").withAlphaComponent(0.7)
        otherView.layer.cornerRadius = 25
        otherView.layer.borderWidth = 1
        otherView.layer.borderColor = UIColor.white.cgColor
        containerRareTag.layer.cornerRadius = 16
        containerRareTag.backgroundColor = .white
        containerHealingTag.layer.cornerRadius = 16
        containerHealingTag.backgroundColor = .white
        
        let width = UIScreen.main.bounds.width
        let secondLayout = UICollectionViewFlowLayout()
        secondLayout.itemSize = .init(width: width - 32, height: 206)
        secondLayout.scrollDirection = .vertical
        secondLayout.minimumLineSpacing = 12
        
        collectionDescription.showsVerticalScrollIndicator = false
        collectionDescription.isScrollEnabled = false
        collectionDescription.backgroundColor = .clear
        collectionDescription.collectionViewLayout = secondLayout
        collectionDescription.dataSource = self
        collectionDescription.delegate = self
        collectionDescription.register(TipsStoneCell.self, forCellWithReuseIdentifier: "TipsStoneCell")
        
        articleTableView.backgroundColor = .clear
        articleTableView.showsVerticalScrollIndicator = false
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.rowHeight = UITableView.noIntrinsicMetric
        articleTableView.separatorStyle = .none
        articleTableView.register(TableViewCell.self, forCellReuseIdentifier: "\(TableViewCell.self)")
        
        firstImageStone.layer.cornerRadius = 16
        firstImageStone.contentMode = .scaleToFill
        firstImageStone.clipsToBounds = true
        
        secondImageStone.layer.cornerRadius = 16
        secondImageStone.contentMode = .scaleToFill
        secondImageStone.clipsToBounds = true
        
        fortinImageStone.layer.cornerRadius = 16
        fortinImageStone.contentMode = .scaleToFill
        fortinImageStone.clipsToBounds = true
        
        thirdImageStone.layer.cornerRadius = 16
        thirdImageStone.contentMode = .scaleToFill
        thirdImageStone.clipsToBounds = true
        containerImageView.layer.cornerRadius = 16
        
        let tapGoToGallery = UITapGestureRecognizer(target: self, action: #selector(goGallery))
        let tapGoToGallery1 = UITapGestureRecognizer(target: self, action: #selector(goGallery))
        let tapGoToGallery2 = UITapGestureRecognizer(target: self, action: #selector(goGallery))

        firstImageStone.isUserInteractionEnabled = true
        firstImageStone.addGestureRecognizer(tapGoToGallery1)

        secondImageStone.isUserInteractionEnabled = true
        secondImageStone.addGestureRecognizer(tapGoToGallery2)

        thirdImageStone.isUserInteractionEnabled = true
        thirdImageStone.addGestureRecognizer(tapGoToGallery)
    }
    
    private func calculateCollectionHeight() {
        var collectionHeight = 0
        if heightCell.count >= 2 {
            collectionHeight += Int(heightCell[1] + heightCell[0]) + 32
        } else if heightCell.count < 2 {
            collectionHeight += Int(heightCell[0]) + 32
        }
        self.collectionHeight.constant = CGFloat(collectionHeight)
        self.collectionDescription.reloadData()
    }
    
    private func setupDataView() {
        guard let rock = dataRock else { return }
        nameStone.text = rock.name
        stoneImgView.setupImgURL(url: rock.image)
        if rock.pricePerCaratFrom?.remove$() == nil && rock.pricePerCaratTo?.remove$() == nil {
            costStone.text = "$0 / carat"
        } else {
            costStone.text = "$\(rock.pricePerCaratFrom?.remove$() ?? "0") - $\(rock.pricePerCaratTo?.remove$() ?? "0") / carat"
        }
        formulaTxt.text = rock.chemicalFormula
        hardnesTxt.text = rock.hardness
        colorTxt.text = rock.colors
        isButtonSelected = rock.isFavorite
        firstImageStone.setupImgURL(url: (dataRock?.photos[0].image) ?? "")
        secondImageStone.setupImgURL(url: (dataRock?.photos[1].image) ?? "")
        thirdImageStone.setupImgURL(url: (dataRock?.photos[2].image) ?? "")
        fortinImageStone.setupImgURL(url: (dataRock?.photos[3].image) ?? "")
        if rock.description != "" {
            titleDiscription.append(rock.description)
        }
        if let health = rock.healthRisks, !health.isEmpty {
            titleDiscription.append(health)
        }
        collectionDescription.reloadData()
        if rock.isFavorite {
            btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
        }
        rock.tags.forEach {
            switch $0.name {
            case "Healing": containerHealingTag.isHidden = false
            case "Rare": containerRareTag.isHidden = false
            default: return
            }
        }
        
        if rock.tags.count == 1 && rock.tags[0].name == "Rare" {
            containerHealingTag.widthAnchor.constraint(equalToConstant: 0).isActive = true
            leadingRareConstraint.constant = 0
            healingTeg.isHidden = true
        }
        
        if rock.tags.count == 0 {
            heightConstraintCart.constant = 160
        }
        btnSeeAll.isEnabled = true
    }
    
    private func getDataStone() {
        loading.addLoading(view: self)
        btnHeart.isEnabled = false
        networkStone.getStoneById(id: String(id)) { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.btnHeart.isEnabled = true
                    self.dataRock = data
                    self.article = []
                    self.article = data.articles
                    self.setupDataView()
                    if self.article.count == 0 {
                        self.bottomConstraint.constant = 20
                        self.titleArticle.isHidden = true
                        self.articleTableView.isHidden = true
                    } else if self.article.count >= 2 {
                        self.bottomConstraint.constant = 500
                    }
                    self.articleTableView.reloadData()
                }
            case .failure(_):
                LoadingIndicator.alertNoEthernet(view: self)
            }
        }
    }
    
    private func localize() {
        backButton.setTitle("", for: .normal)
        btnHeart.setTitle("", for: .normal)
        btnSeeAll.setTitle("cart_see_all".localized, for: .normal)
        formulaLable.text = "cart_formula".localized
        formulaLable.adjustsFontSizeToFitWidth = true
        hardnessLable.text = "cart_hardness".localized
        hardnessLable.adjustsFontSizeToFitWidth = true
        colorLable.text = "cart_colors".localized
        colorLable.adjustsFontSizeToFitWidth = true
        rareTeg.text = "cart_tag_rare".localized
        healingTeg.text = "cart_tag_healing".localized
        titleArticle.text = "cart_title_article".localized
    }
    
    private func gallery() {
        let vc = GaleryViewController()
        vc.photos = dataRock?.photos ?? []
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension CartStoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        article.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(TableViewCell.self)", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.titleText.text = article[indexPath.row]!.title
        cell.imageViewBase.setupImgURL(url: article[indexPath.row]!.thumbnail)
        return cell
    }
}

extension CartStoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleViewController()
        vc.id = String(article[indexPath.row]!.id)
        present(vc, animated: true)
    }
}

extension CartStoneViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = titleDiscription[indexPath.row]
        let cellWidth = UIScreen.main.bounds.width - 32
        let height = TipsStoneCell.calculateCellHeight(for: item, width: cellWidth) + 50
        heightCell.append(height)
        if titleDiscription.count == heightCell.count { calculateCollectionHeight() }
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return titleDiscription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TipsStoneCell.self)" , for: indexPath) as? TipsStoneCell else { return UICollectionViewCell() }
        cell.text.text = titleDiscription[indexPath.row]
        if indexPath.row == 0 {
            cell.titleCell.text = "cart_description".localized
        } else {
            cell.titleCell.text = "cart_healing".localized
        }
        return cell
    }
}

