

import UIKit
import NVActivityIndicatorView

final class HealingViewController: UIViewController {
    
    var alertController: UIAlertController?
    var dataRocks: [RockTagsResult] = []
    let networkStone = NetworkStoneImpl()
    let buttonView = ButtonView()
    let loading = Loading()
     
    @IBOutlet weak var collectionViewHealing: UICollectionView!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var titleHealing: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        AnalyticsManager.shared.logEvent(name: Events.open_healing_stone)
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHealingStone()
    }
    
    @IBAction func goToBack(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension HealingViewController {
    private func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 44) / 2, height: 196)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 11
        layout.scrollDirection = .vertical
        
        collectionViewHealing.isHidden = true
        collectionViewHealing.showsVerticalScrollIndicator = false
        collectionViewHealing.backgroundColor = UIColor.clear
        collectionViewHealing.collectionViewLayout = layout
        collectionViewHealing.contentInset = .init(top: 0, left: 0, bottom: 90, right: 0)
        collectionViewHealing.dataSource = self
        collectionViewHealing.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        backButton.setTitle("", for: .normal)
        titleHealing.text = "h_title_healing".localized
        
        buttonContainer.layer.cornerRadius = 25
        buttonContainer.backgroundColor = .clear
        buttonView.delegate = self
        buttonContainer.frame = buttonView.frame
        buttonView.setupAnimation()
        buttonContainer.addSubview(buttonView)
        buttonContainer.layer.shadowColor = UIColor.black.cgColor
        buttonContainer.layer.shadowOpacity = 0.2
        buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        buttonContainer.layer.shadowRadius = 10
        buttonContainer.isHidden = true
    }
    
    private func getHealingStone() {
        loading.addLoading(view: self)
        networkStone.getStonesByTag(tag: "2") { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case.success(let data):
                DispatchQueue.main.async {
                    self.dataRocks = data.results
                    self.collectionViewHealing.reloadData()
                    self.buttonContainer.isHidden = false
                    self.collectionViewHealing.isHidden = false
                }
            case.failure(_):
                LoadingIndicator.alertNoEthernet(view: self)
            }
        }
    }
}

extension HealingViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HealingViewController: CartStoneDelegate {
    func setLoadIndicator() {
    }
    
    func checkInternet() {
        LoadingIndicator.alertNoEthernet(view: self)
    }
    
    func addToCollection() {
        getHealingStone()
    }
    
    func deleteFromCollection() {
        getHealingStone()
    }
    
    func openStone(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HealingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataRocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoneCollectionViewCell", for: indexPath) as! StoneCollectionViewCell
        cell.cellView.delegate = self
        cell.cellView.titleStone.text = dataRocks[indexPath.row].name
        cell.cellView.priceStone.text = "\(dataRocks[indexPath.row].pricePerCaratTo?.remove$() ?? "0") / ct"
        cell.cellView.id = dataRocks[indexPath.row].id
        cell.cellView.imageStone.setupImgURL(url:  dataRocks[indexPath.row].image)
        cell.cellView.isButtonSelected = dataRocks[indexPath.row].isFavorite
        if dataRocks[indexPath.row].isFavorite {
            cell.cellView.btnHeart.setImage(UIImage(named: "fillheart"), for: .normal)
        } else { cell.cellView.btnHeart.setImage(UIImage(named: "heart"), for: .normal) }
        return cell
    }
}

