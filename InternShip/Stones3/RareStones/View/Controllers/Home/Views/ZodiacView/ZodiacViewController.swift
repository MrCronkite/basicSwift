

import UIKit
import Lottie
import GoogleMobileAds
import NVActivityIndicatorView

final class ZodiacViewController: UIViewController {
    
    var zodiacCategory: [Results] = []
    var zodiacStones: [StoneElements] = []
    let networkService = NetworkServicesZodiacImpl()
    let buttonViewAnimate = ButtonView()
    var selectedIndexPath: IndexPath?
    let loading = Loading()
    
    @IBOutlet weak var bottomButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataOfBirthLable: UILabel!
    @IBOutlet weak var titleZodiac: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var heightBoxView: NSLayoutConstraint!
    @IBOutlet weak var elementTxt: UILabel!
    @IBOutlet weak var boxZodiac: UIView!
    @IBOutlet weak var imageZodiac: UIImageView!
    @IBOutlet weak var dataBirthText: UILabel!
    @IBOutlet weak var elementText: UILabel!
    @IBOutlet weak var zodiacCollection: UICollectionView!
    @IBOutlet weak var stoneTableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupView()
        getZodiac()
        loadAd()
        
        if UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey) {
            bannerView.isHidden = true
            bottomButtomConstraint.constant = 30
            bottomTableConstraint.constant = 0
        }
        
        AnalyticsManager.shared.logEvent(name: Events.open_zodiac)
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
        boxZodiac.setupGradient()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !zodiacStones.isEmpty {
            selectedIndexPath = IndexPath(item: 0, section: 0)
            zodiacCollection.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
        }
    }
    
    @IBAction func goToBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension ZodiacViewController {
    private func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 88, height: 32)
        layout.scrollDirection = .horizontal
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.itemSize = .init(width: 363, height: 300)
        layout1.scrollDirection = .vertical
        
        zodiacCollection.isHidden = true
        zodiacCollection.contentInset = .init(top: 0, left: 16, bottom: 0, right: 0)
        zodiacCollection.collectionViewLayout = layout
        zodiacCollection.showsHorizontalScrollIndicator = false
        zodiacCollection.backgroundColor = .clear
        zodiacCollection.dataSource = self
        zodiacCollection.delegate = self
        zodiacCollection.register(ZodiacCollectionCell.self, forCellWithReuseIdentifier: "\(ZodiacCollectionCell.self)")
        
        stoneTableView.isHidden = true
        stoneTableView.contentInset = .init(top: 30, left: 0, bottom: 110, right: 0)
        stoneTableView.backgroundColor = .clear
        stoneTableView.showsVerticalScrollIndicator = false
        stoneTableView.dataSource = self
        stoneTableView.delegate = self
        stoneTableView.rowHeight = UITableView.noIntrinsicMetric
        stoneTableView.separatorStyle = .none
        stoneTableView.register(StoneZodiacCell.self, forCellReuseIdentifier: "\(StoneZodiacCell.self)")
        
        elementTxt.greyColor()
        dataOfBirthLable.greyColor()
        boxZodiac.backgroundColor = R.Colors.blueLight
        boxZodiac.layer.cornerRadius = 20
        boxZodiac.layer.borderWidth = 1
        boxZodiac.layer.borderColor = UIColor.white.cgColor
        boxZodiac.isHidden = true
        imageZodiac.contentMode = .scaleAspectFill
        
        viewButton.layer.cornerRadius = 25
        viewButton.backgroundColor = .clear
        buttonViewAnimate.delegate = self
        viewButton.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        viewButton.addSubview(buttonViewAnimate)
        viewButton.layer.shadowColor = UIColor.black.cgColor
        viewButton.layer.shadowOpacity = 0.2
        viewButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewButton.layer.shadowRadius = 10
        viewButton.isHidden = true
    }
    
    private func loadAd() {
        let ad = GoogleAd.loadBaner()
        ad.rootViewController = self
        bannerView.addBannerViewToView(ad)
    }
    
    private func localize() {
        backButton.setTitle("", for: .normal)
        elementTxt.text = "h_zodiac_element".localized
        dataOfBirthLable.text = "h_dataofbirth".localized
        titleZodiac.text = "h_zodiac_title".localized
    }
    
    private func getZodiacForId(id: String) {
        networkService.getZodiacInId(id: id) { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.dataBirthText.text = data.dateRange
                    self.elementText.text = data.element
                    self.imageZodiac.setupImgURL(url: data.image)
                    self.zodiacStones = data.stones
                    self.boxZodiac.isHidden = false
                    self.zodiacCollection.isHidden = false
                    self.viewButton.isHidden = false
                    self.stoneTableView.isHidden = false
                    self.stoneTableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                    DispatchQueue.main.async {
                        LoadingIndicator.alertNoEthernet(view: self)
                    }
                }
            }
        }
    }
    
    private func getZodiac() {
        loading.addLoading(view: self)
        networkService.getZodiacData() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.zodiacCategory = data.results
                    self.zodiacCollection.reloadData()
                    self.getZodiacForId(id: "1")
                }
            case .failure(_):
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                    DispatchQueue.main.async {
                        LoadingIndicator.alertNoEthernet(view: self)
                    }
                }
            }
        }
    }
}

extension ZodiacViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZodiacViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        zodiacStones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(StoneZodiacCell.self)", for: indexPath) as? StoneZodiacCell else { return UITableViewCell()}
        cell.imageStoneView.setupImgURL(url: zodiacStones[indexPath.row].stone.image)
        cell.nameStone.text = zodiacStones[indexPath.row].stone.name
        cell.titleStone.text = zodiacStones[indexPath.row].description
        cell.selectionStyle = .none
       // cell.containerView.setupGradient()
        return cell
    }
}

extension ZodiacViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = zodiacStones[indexPath.row].description
        let cellWidth = tableView.frame.width
        let height = TipsStoneCell.calculateCellHeight(for: item, width: cellWidth)
        return height + 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CartStoneViewController()
        vc.id = zodiacStones[indexPath.row].stone.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZodiacViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        zodiacCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ZodiacCollectionCell.self)", for: indexPath) as? ZodiacCollectionCell
        else { return UICollectionViewCell() }
        cell.lableTextCell.text = zodiacCategory[indexPath.row].name
        return cell
    }
}

extension ZodiacViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousSelectedIndexPath = selectedIndexPath {
                if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? ZodiacCollectionCell {
                    previousSelectedCell.isSelected = false
                }
            }
            
            // Устанавливаем новую активную ячейку
            selectedIndexPath = indexPath
            
            // Вызываем метод получения данных для новой активной ячейки
            getZodiacForId(id: String(indexPath.row + 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let previousSelectedIndexPath = selectedIndexPath {
                if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? ZodiacCollectionCell {
                    previousSelectedCell.isSelected = false
                }
            }
            
            // Очищаем `selectedIndexPath`, чтобы не было активной ячейки
            selectedIndexPath = nil
    }
}
