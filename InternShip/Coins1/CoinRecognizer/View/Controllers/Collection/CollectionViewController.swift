

import UIKit
import GoogleMobileAds
import Kingfisher

final class CollectionViewController: UIViewController {
    
    var presenter: CollectionPresenter!
    
    @IBOutlet weak private var imagePremium: UIImageView!
    @IBOutlet weak private var containerPremium: UIView!
    @IBOutlet weak private var collectionBtn: UIButton!
    @IBOutlet weak private var historyBtn: UIButton!
    @IBOutlet weak private var favoritesBtn: UIButton!
    @IBOutlet weak private var colletionViewFolder: UICollectionView!
    @IBOutlet weak private var cameraBtn: UIButton!
    @IBOutlet weak private var navbar: NavbarView!
    @IBOutlet weak private var tableViewHistory: UITableView!
    @IBOutlet weak private var lablePremium: UILabel!
    @IBOutlet weak private var lableSubtitlePremium: UILabel!
    @IBOutlet weak private var premiumViewButton: UIView!
    @IBOutlet weak private var containerEmptyTitle: UIView!
    @IBOutlet weak private var subtitleEmpty: UILabel!
    @IBOutlet weak private var titleEmpy: UILabel!
    @IBOutlet weak private var getLable: UILabel!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
       
        AnaliticsService.shared.logEvent(name: Events.opne_collection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch presenter.selectedCategory {
        case .collection: presenter.loadCollection()
        case .history: presenter.loadHistory()
        case .favorites: presenter.loadFavorites()
        }
    }
    
    override func viewDidLayoutSubviews() {
        containerPremium.setupThreeGradient(startColor: Asset.Color.gold3.color,
                                            middleColor: Asset.Color.gold1.color,
                                            endColor: Asset.Color.gold3.color)
        favoritesBtn.titleLabel?.numberOfLines = 1
        favoritesBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        collectionBtn.titleLabel?.numberOfLines = 1
        collectionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        cameraBtn.isHidden = false
    }
    
    @IBAction func showCamera(_ sender: Any) {
        presenter.tapOnTheCamera()
        cameraBtn.isHidden = true
    }
    
    @objc func tapInButton(_ sender: UIButton) {
        collectionBtn.tintColor = Asset.Color.textGray.color
        collectionBtn.layer.borderWidth = 1
        collectionBtn.backgroundColor = .white
        
        historyBtn.tintColor = Asset.Color.textGray.color
        historyBtn.layer.borderWidth = 1
        historyBtn.backgroundColor = .white
        
        favoritesBtn.tintColor = Asset.Color.textGray.color
        favoritesBtn.layer.borderWidth = 1
        favoritesBtn.backgroundColor = .white
        
        sender.layer.borderWidth = 0
        sender.backgroundColor = Asset.Color.orange.color
        sender.tintColor = .white
        sender.addTapEffect()
        switch sender.titleLabel?.text {
        case "btn_collection".localized: presenter.loadCollection()
        case "btn_history".localized: presenter.loadHistory()
        case "btn_favorites".localized: presenter.loadFavorites()
        case .none: break
        case .some(_): break
        }
    }
    
    @objc func goPremium() {
        presenter.tapGoPremium()
    }
    
    @objc private func refreshTableView(_ sender: UIRefreshControl) {
        switch presenter.selectedCategory {
        case .history:
            presenter.loadHistory()
        case .favorites:
            presenter.loadFavorites()
        default: break
        }
        
        sender.endRefreshing()
    }
}

private extension CollectionViewController {
    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navbar.delegate = self
        navbar.setupStyleNavBar(title: "", style: .nativ)
        
        cameraBtn.layer.cornerRadius = 40
        cameraBtn.setImage(Asset.Assets.cameraLogo.image, for: .normal)
        cameraBtn.backgroundColor = Asset.Color.orange.color
        cameraBtn.setTitle("", for: .normal)
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 43) / 2, height: 196)
        layout.minimumLineSpacing = 9
        layout.scrollDirection = .vertical
        
        colletionViewFolder.collectionViewLayout = layout
        colletionViewFolder.contentInset.bottom = 150
        colletionViewFolder.backgroundColor = .clear
        colletionViewFolder.dataSource = self
        colletionViewFolder.register(CollectionCellFolder.self, forCellWithReuseIdentifier: "\(CollectionCellFolder.self)")
        
        collectionBtn.layer.cornerRadius = 18
        collectionBtn.layer.borderWidth = 0
        collectionBtn.layer.borderColor = Asset.Color.textGray.color.cgColor
        collectionBtn.backgroundColor = Asset.Color.orange.color
        collectionBtn.tintColor = .white
    
        historyBtn.layer.cornerRadius = 18
        historyBtn.layer.borderWidth = 1
        historyBtn.layer.borderColor = Asset.Color.textGray.color.cgColor
        historyBtn.backgroundColor = .white
        historyBtn.tintColor = Asset.Color.textGray.color
        
        favoritesBtn.layer.cornerRadius = 18
        favoritesBtn.layer.borderWidth = 1
        favoritesBtn.layer.borderColor = Asset.Color.textGray.color.cgColor
        favoritesBtn.backgroundColor = .white
        favoritesBtn.tintColor = Asset.Color.textGray.color
        
        
        collectionBtn.addTarget(self, action: #selector(tapInButton(_:)), for: .touchUpInside)
        historyBtn.addTarget(self, action: #selector(tapInButton(_:)), for: .touchUpInside)
        favoritesBtn.addTarget(self, action: #selector(tapInButton(_:)), for: .touchUpInside)
        
        tableViewHistory.isHidden = true
        tableViewHistory.dataSource = self
        tableViewHistory.delegate = self
        tableViewHistory.rowHeight = UITableView.automaticDimension
        tableViewHistory.separatorStyle = .none
        tableViewHistory.backgroundColor = .clear
        tableViewHistory.register(CoinTableCell.self, forCellReuseIdentifier: "\(CoinTableCell.self)")
        
        containerPremium.layer.cornerRadius = 20
        containerPremium.clipsToBounds = true
        imagePremium.image = Asset.Assets.premiumCoins.image
        premiumViewButton.layer.cornerRadius = 20
        
        let tapGoToPremium = UITapGestureRecognizer(target: self, action: #selector(goPremium))
        premiumViewButton.isUserInteractionEnabled = true
        premiumViewButton.addGestureRecognizer(tapGoToPremium)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        tableViewHistory.refreshControl = refreshControl
        
        let tabBarHeight = tabBarController?.tabBar.bounds.height
        bottomConstraint.constant = (tabBarHeight ?? 40) / 1.8
    }
    
    func setupEmptyTitle() {
        switch presenter.selectedCategory {
        case .history:
            if presenter.historyCoins.isEmpty {
                containerEmptyTitle.isHidden = false
                titleEmpy.text = R.Strings.Collection.history.first
                subtitleEmpty.text = R.Strings.Collection.history.last
            } else {
                containerEmptyTitle.isHidden = true
            }
        case .favorites:
            if presenter.whislist.isEmpty {
                containerEmptyTitle.isHidden = false
                titleEmpy.text = R.Strings.Collection.favorites.first
                subtitleEmpty.text = R.Strings.Collection.favorites.last
            } else {
                containerEmptyTitle.isHidden = true
            }
        default:  containerEmptyTitle.isHidden = true
        }
    }
    
    func localize() {
        collectionBtn.setTitle("btn_collection".localized, for: .normal)
        historyBtn.setTitle("btn_history".localized, for: .normal)
        historyBtn.titleLabel?.numberOfLines = 1
        historyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        favoritesBtn.setTitle("btn_favorites".localized, for: .normal)
        favoritesBtn.titleLabel?.numberOfLines = 1
        favoritesBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        getLable.text = "get_fold".localized
        lablePremium.text = "prem_folder".localized
        lableSubtitlePremium.text = "spesial_price".localized
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionCellFolder.self)", for: indexPath) as? CollectionCellFolder else { return UICollectionViewCell() }
        cell.imageViewFolder.image = presenter.itemImages[indexPath.row]
        cell.setColorView(color: presenter.itemColors[indexPath.row])
        cell.nameCollection.text = presenter.collections[indexPath.row].name
        cell.nameCollection.textColor = presenter.itemColors[indexPath.row]
        //cell.lableCountCoins.text = "(\(presenter.allCoins[indexPath.row].count) coins)"
        cell.setCollection()
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            cell.setFolder()
        }
        
        cell.buttonAddCollection = {
            self.presenter.tapOnTheSetNameView()
            cell.addTapEffect()
        }
        cell.buttonOpenCollection = {
            DispatchQueue.main.async {
                self.presenter.getCollection(id: indexPath.row)
                cell.addTapEffect()
            }
        }
        
        return cell
    }
}

extension CollectionViewController: NavBarViewDelegate {
    func showSettings() {
        presenter.tapOnTheSettings()
        cameraBtn.isHidden = true
    }
    
    func openWallet() {
        presenter.loadCollection()
        
        collectionBtn.tintColor = .white
        collectionBtn.layer.borderWidth = 0
        collectionBtn.backgroundColor = Asset.Color.orange.color
        
        historyBtn.tintColor = Asset.Color.textGray.color
        historyBtn.layer.borderWidth = 1
        historyBtn.backgroundColor = .white
        
        favoritesBtn.tintColor = Asset.Color.textGray.color
        favoritesBtn.layer.borderWidth = 1
        favoritesBtn.backgroundColor = .white
    }
}

extension CollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.addTapEffect()
            switch presenter.selectedCategory {
            case .history:
                presenter?.getHistoryInId(id: indexPath.row)
            case .favorites:
                presenter.getWishlistInId(id: indexPath.row)
            default: break
            }
        }
    }
}

extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch presenter.selectedCategory {
        case .history:
            return presenter.historyCoins.count
        case .favorites:
            return presenter.whislist.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CoinTableCell.self)", for: indexPath) as? CoinTableCell else { return UITableViewCell() }
        switch presenter.selectedCategory {
        case .history:
            cell.lableCostCoin.text = presenter.historyCoins[indexPath.row].results.first?.name
            cell.ImageViewCoin.image(url: presenter.historyCoins[indexPath.row].image)
            let priceFrom = presenter.historyCoins[indexPath.row].results.first?.reference.priceFrom ?? "$0"
            let priceTo = presenter.historyCoins[indexPath.row].results.first?.reference.priceTo ?? "$0"
            cell.lablePrice.text = "\(priceFrom) - \(priceTo)"
            cell.lableYears.text = presenter.historyCoins[indexPath.row].results.first?.reference.dateRange.replacingCurrentYear()
            
        case .favorites:
            cell.lableCostCoin.text = presenter.whislist[indexPath.row].reference.name
            cell.ImageViewCoin.image(url: presenter.whislist[indexPath.row].reference.imageObverse ?? "")  
            let priceFrom = presenter.whislist[indexPath.row].reference.priceFrom
            let priceTo = presenter.whislist[indexPath.row].reference.priceTo
            cell.lablePrice.text = "\(priceFrom) - \(priceTo)"
            cell.lableYears.text = presenter.whislist[indexPath.row].reference.dateRange.replacingCurrentYear()

        default: break
        }
        
        cell.selectionStyle = .none
        cell.buttonTrash.isHidden = true
        return cell
    }
}

extension CollectionViewController: CollectionViewProtocol {
    func hideButton() {
        cameraBtn.isHidden = true
    }
    
    func updateFolder() {
        colletionViewFolder.reloadData()
    }
    
    func updateCollection() {
        setupEmptyTitle()
        colletionViewFolder.isHidden = false
        tableViewHistory.isHidden = true
        colletionViewFolder.reloadData()
        navbar.setWalletPrice()
        
        
        if (presenter.sotorage?.premium(forKey: .keyPremium) ?? true) {
            containerPremium.isHidden = true
        }
    }
    
    func updateHistory() {
        setupEmptyTitle()
        colletionViewFolder.isHidden = true
        tableViewHistory.isHidden = false
        containerPremium.isHidden = true
        tableViewHistory.reloadData()
    }
    
    func updateFavorites() {
        setupEmptyTitle()
        colletionViewFolder.isHidden = true
        tableViewHistory.isHidden = false
        containerPremium.isHidden = true
        tableViewHistory.reloadData()
    }
    
    func succes() {
        colletionViewFolder.reloadData()
    }
}
