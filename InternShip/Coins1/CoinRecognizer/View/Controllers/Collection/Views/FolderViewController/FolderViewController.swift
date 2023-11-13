

import UIKit
import GoogleMobileAds
import Kingfisher

final class FolderViewController: UIViewController {
    
    var presenter: FolderPresenter?
    
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var tableViewCoins: UITableView!
    @IBOutlet weak private var containerTitleView: UIView!
    @IBOutlet weak private var addCoinButton: UIButton!
    @IBOutlet weak private var titleText: UILabel!
    @IBOutlet weak private var subtitleText: UILabel!
    @IBOutlet weak private var adContainer: UIView!
    @IBOutlet weak private var footerView: UIView!
    @IBOutlet weak private var containerShadow: UIView!
    @IBOutlet weak private var textContainer: UIView!
    @IBOutlet weak private var animeView: UIView!
    @IBOutlet weak private var congratTitle: UILabel!
    @IBOutlet weak private var subtitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.loadBanner()
        presenter?.showAlert()
        presenter?.setupView()
        localize()
    }
    
    override func viewDidLayoutSubviews() {
        footerView.roundTopCorners(radius: 40)
        animeView.setupAnimation(name: "coins2")
    }
    
    @IBAction private func addCoinToColection(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        presenter?.addNewCoinToCollection()
    }
}

private extension FolderViewController {
    func setupView() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        navBar.delegate = self
        
        tableViewCoins.separatorStyle = .none
        tableViewCoins.backgroundColor = .clear
        tableViewCoins.dataSource = self
        tableViewCoins.delegate = self
        tableViewCoins.rowHeight = UITableView.automaticDimension
        tableViewCoins.register(CoinTableCell.self, forCellReuseIdentifier: "\(CoinTableCell.self)")
        containerTitleView.isHidden = true
        addCoinButton.setTitle("add_new_coins".localized, for: .normal)
        addCoinButton.titleLabel?.textAlignment = .center
        addCoinButton.backgroundColor = Asset.Color.orange.color
        addCoinButton.tintColor = .white
        addCoinButton.layer.cornerRadius = 27
        containerShadow.backgroundColor = .black.withAlphaComponent(0.5)
        containerShadow.isHidden = true
        textContainer.backgroundColor = Asset.Color.original.color.withAlphaComponent(1)
        textContainer.layer.cornerRadius = 16
    }
    
    func localize() {
        titleText.text = "folder_empty".localized
        subtitleText.text = "folder_empty_sub".localized
        congratTitle.text = "folder_congrat".localized
        subtitle.text = "folder_congrat_sub".localized
    }
}

extension FolderViewController: NavBarViewDelegate {
    func goBack() {
        presenter?.goBack()
    }
    
    func delete() {
        presenter?.deleteOrRename()
    }
}

extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.collection?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CoinTableCell.self)", for: indexPath) as? CoinTableCell else { return UITableViewCell() }
        cell.ImageViewCoin.image(url: (presenter?.collection?.items[indexPath.row].userPhotos.first??.image ?? ""))
        cell.lableCostCoin.text = presenter?.collection?.items[indexPath.row].reference.name
        cell.lableYears.text = presenter?.collection?.items[indexPath.row].reference.dateRange.replacingCurrentYear()
        
        let from = presenter?.collection?.items[indexPath.row].reference.priceFrom ?? "$0"
        let to = presenter?.collection?.items[indexPath.row].reference.priceTo ?? "$0"
        cell.lablePrice.text = "\(from) - \(to)"
        cell.selectionStyle = .none
        cell.buttonTapped = {
            self.presenter?.deleteItem(id: indexPath.row)
        }
        return cell
    }
}

extension FolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToCoin(id: indexPath.row)
    }
}

extension FolderViewController: FolderViewProtocol {
    func reloadData() {
        navBar.setupStyleNavBar(title: presenter?.collection?.name ?? "",
                                style: .folder)
        if presenter?.collection?.items.count == 0 {
            containerTitleView.isHidden = false
        }
        tableViewCoins.reloadData()
    }
    
    func hideShadowView() {
        containerShadow.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.containerShadow.isHidden = true
        }
    }
    
    func setupBanner(ad: GADBannerView) {
        ad.rootViewController = self
        adContainer.addBannerViewToView(ad)
        adContainer.isHidden = false
        tableViewCoins.contentInset = .init(top: 0, left: 0, bottom: 70, right: 0)
    }
}
