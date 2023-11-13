

import UIKit
import GoogleMobileAds

final class AllCoinsViewController: UIViewController {
    
    var presenter: AllCoinsPresenter?
    private var tapGesture: UITapGestureRecognizer?
  
    @IBOutlet weak private var shadowView: UIView!
    @IBOutlet weak private var navBar: NavbarView!
    @IBOutlet weak private var textFieldSearch: UITextField!
    @IBOutlet weak private var filterBtn: UIButton!
    @IBOutlet weak private var tableViewCoins: UITableView!
    @IBOutlet weak private var footerView: UIView!
    @IBOutlet weak private var adContainer: UIView!
    @IBOutlet weak private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak private var noMatchLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.loadBanner()
        presenter?.loadAllCoins()
        localize()
    }
    
    @IBAction private func showFilterView(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        shadowView.isHidden = false
        presenter?.tapOnTheFilter()
    }
    
    
    @IBAction private func searching(_ sender: UITextField) {
        presenter?.filterForSearchText(sender.text)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let tapGesture = tapGesture {
            view.removeGestureRecognizer(tapGesture)
        }
    }
}

extension AllCoinsViewController {
    private func setupView() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        navBar.delegate = self
        
        filterBtn.setTitle("", for: .normal)
        filterBtn.setImage(Asset.Assets.filtr.image, for: .normal)
        
        let iconImageView = UIImageView(image: Asset.Assets.searchText.image)
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textFieldSearch.frame.height))
        leftView.addSubview(iconImageView)
        
        textFieldSearch.leftView = leftView
        textFieldSearch.textColor = .black
        textFieldSearch.leftViewMode = .always
        textFieldSearch.backgroundColor = Asset.Color.lightBlue.color
        textFieldSearch.layer.cornerRadius = 10
        textFieldSearch.borderStyle = .none
        textFieldSearch.delegate = self
        textFieldSearch.addDoneButtonOnKeyboard()
        textFieldSearch.autocorrectionType = .no
        
        tableViewCoins.backgroundColor = .clear
        tableViewCoins.dataSource = self
        tableViewCoins.delegate = self
        tableViewCoins.rowHeight = UITableView.noIntrinsicMetric
        tableViewCoins.separatorStyle = .none
        tableViewCoins.register(CoinTableCell.self, forCellReuseIdentifier: "\(CoinTableCell.self)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func localize() {
        let placeholderText = "search".localized
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Asset.Color.textGray.color,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        textFieldSearch.attributedPlaceholder = attributedPlaceholder
        
        navBar.setupStyleNavBar(title: "home_all_coins".localized, style: .back)
        noMatchLable.text = "no_results".localized
    }
}

extension AllCoinsViewController: NavBarViewDelegate {
    func goBack() {
        presenter?.goToBack()
    }
}

extension AllCoinsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.filteredItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CoinTableCell.self)", for: indexPath) as? CoinTableCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.buttonTrash.isHidden = true
        
        let priceFrom = presenter?.filteredItems[indexPath.row].priceFrom ?? "0"
        let priceTo = presenter?.filteredItems[indexPath.row].priceTo ?? "0"
        cell.lableCostCoin.text = presenter?.filteredItems[indexPath.row].name
        cell.lablePrice.text = "\(priceFrom) - \(priceTo)"
        cell.lableYears.text = presenter?.filteredItems[indexPath.row].dateRange.replacingCurrentYear()
        cell.ImageViewCoin.image(url: presenter?.filteredItems[indexPath.row].imageObverse ?? "")
        return cell
    }
}

extension AllCoinsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = presenter?.coins[indexPath.row].name
        let font = UIFont.systemFont(ofSize: 18.0)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]

        let textSize = (text as? NSString)!.size(withAttributes: attributes)
        if textSize.width > 230 {
            return 145
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.addTapEffect()
            presenter?.goToCard(index: indexPath.row)
        }
    }
}

extension AllCoinsViewController: AllCoinsViewProtocol {
    func noMatchLable(isShow: Bool) {
        if isShow {
            noMatchLable.isHidden = true
        } else {
            noMatchLable.isHidden = false
        }
    }
    
    func setupBanner(ad: GADBannerView) {
        ad.rootViewController = self
        adContainer.addBannerViewToView(ad)
        footerView.isHidden = false
        tableViewCoins.contentInset = .init(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func reloadDataForSettings() {
        shadowView.isHidden = true
        if presenter?.filter != nil {
            filterBtn.setImage(Asset.Assets.filtrFill.image, for: .normal)
        } else {
            filterBtn.setImage(Asset.Assets.filtr.image, for: .normal)
        }
        tableViewCoins.reloadData()
    }
}

extension AllCoinsViewController: UITextFieldDelegate {
}

