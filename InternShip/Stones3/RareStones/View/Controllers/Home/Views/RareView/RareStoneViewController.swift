

import UIKit
import NVActivityIndicatorView

final class RareStoneViewController: UIViewController {
    
    var alertController: UIAlertController?
    var dataRocks: [RockTagsResult] = []
    let networkStone = NetworkStoneImpl()
    let buttonViewAnimate = ButtonView()
    let loading = Loading()
    
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rareColletion: UICollectionView!
    @IBOutlet weak var titleRare: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getRareStone()
        AnalyticsManager.shared.logEvent(name: Events.open_rare_stone)
    }
    
    override func viewWillLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension RareStoneViewController {
    private func setupView() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        let width = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: (width - 44) / 2, height: 196)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 11
        layout.scrollDirection = .vertical
        
        rareColletion.showsVerticalScrollIndicator = false
        rareColletion.backgroundColor = UIColor.clear
        rareColletion.collectionViewLayout = layout
        rareColletion.contentInset = .init(top: 0, left: 0, bottom: 90, right: 0)
        rareColletion.dataSource = self
        rareColletion.register(StoneCollectionViewCell.self, forCellWithReuseIdentifier: "StoneCollectionViewCell")
        
        backButton.setTitle("", for: .normal)
        titleRare.text = "h_title_rare".localized
        
        buttonContainer.layer.cornerRadius = 25
        buttonContainer.backgroundColor = .clear
        buttonViewAnimate.delegate = self
        buttonContainer.frame = buttonViewAnimate.frame
        buttonViewAnimate.setupAnimation()
        buttonContainer.addSubview(buttonViewAnimate)
        buttonContainer.layer.shadowColor = UIColor.black.cgColor
        buttonContainer.layer.shadowOpacity = 0.2
        buttonContainer.layer.shadowOffset = CGSize(width: 0, height: 10)
        buttonContainer.layer.shadowRadius = 10
        
        buttonContainer.isHidden = true
        rareColletion.isHidden = true
    }
    
    private func getRareStone() {
        loading.addLoading(view: self)
        networkStone.getStonesByTag(tag: "1") { [weak self] result in
            guard let self = self else { return }
            loading.deleleLoader()
            switch result {
            case.success(let data): 
                DispatchQueue.main.async {
                    self.dataRocks = data.results
                    self.buttonContainer.isHidden = false
                    self.rareColletion.isHidden = false
                    self.rareColletion.reloadData()
                }
            case.failure(_):
                LoadingIndicator.alertNoEthernet(view: self)
            }
        }
    }
}

extension RareStoneViewController: ButtonViewDelegate {
    func showCamera() {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RareStoneViewController: CartStoneDelegate {
    func setLoadIndicator() {
    }
    
    func checkInternet() {
        LoadingIndicator.alertNoEthernet(view: self)
    }
    
    func addToCollection() {
        getRareStone()
    }
    
    func deleteFromCollection() {
        getRareStone()
    }
    
    func openStone(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RareStoneViewController: UICollectionViewDataSource {
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






