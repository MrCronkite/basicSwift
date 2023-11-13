

import UIKit
import StoreKit

final class MatchViewController: UIViewController {
    
    var matchStones: StonePhoto? = nil
    var otherStones: [StoneClassificationResultModel] = []
    var alertController: UIAlertController?
    var tabBar: TabBarController?
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var boxImgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var percentBox: UIView!
    @IBOutlet weak var percentTxt: UILabel!
    @IBOutlet weak var collectionOther: UICollectionView!
    
    @IBOutlet weak var otherLable: UILabel!
    @IBOutlet weak var upToText: UILabel!
    @IBOutlet weak var matchText: UILabel!
    @IBOutlet weak var containerStoneView: UIView!
    @IBOutlet weak var imageStoneView: UIImageView!
    @IBOutlet weak var lableStone: UILabel!
    @IBOutlet weak var priceStone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        setupView()
        localize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                guard let scene = self.view.window?.windowScene else {
                    return
                }
                SKStoreReviewController.requestReview(in: scene)
            }
        }
        
        AnalyticsManager.shared.logEvent(name: Events.open_view_match)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        containerStoneView.setupPulsingAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        view.setupLayer()
    }
    
    @IBAction func goToBack(_ sender: Any) {
        AnalyticsManager.shared.logEvent(name: Events.close_view_mathc)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func togle(_ sender: UITapGestureRecognizer) {
        let vc = CartStoneViewController()
        vc.id = matchStones?.results[0].stone.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func appWillEnterForeground() {
        containerStoneView.setupPulsingAnimation()
    }
}

extension MatchViewController{
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(togle(_ :)))
        containerStoneView.addGestureRecognizer(tap)
        containerStoneView.isUserInteractionEnabled = true
        
        boxImgView.layer.cornerRadius = 20
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 14
        percentBox.layer.cornerRadius = 43
        percentTxt.text = "\(Int.random(in: 86...98))%"
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 134, height: 157)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        collectionOther.showsHorizontalScrollIndicator = false
        collectionOther.backgroundColor = UIColor.clear
        collectionOther.collectionViewLayout = layout
        collectionOther.contentInset = .init(top: 0, left: 16, bottom: 0, right: 0)
        collectionOther.dataSource = self
        collectionOther.register(MatchCell.self, forCellWithReuseIdentifier: "MatchCell")
        
        imageStoneView.clipsToBounds = true
        imageStoneView.layer.cornerRadius = 12
        imageStoneView.contentMode = .scaleAspectFill
        containerStoneView.layer.cornerRadius = 16
        
        containerStoneView.layer.shadowColor = UIColor.black.cgColor
        containerStoneView.layer.shadowOffset = CGSize(width: 0, height: 7)
        containerStoneView.layer.shadowOpacity = 0.3
        containerStoneView.layer.shadowRadius = 5
    }
    
    private func setupViewData() {
        guard let data = matchStones else { return }
        DispatchQueue.main.async {
            self.imgView.setupImgURL(url: data.image)
            self.imageStoneView.setupImgURL(url: data.results[0].stone.image)
            self.lableStone.text = data.results[0].stone.name
            self.priceStone.text = "\(data.results[0].stone.pricePerCaratTo?.remove$() ?? "$0") / ct"
            self.otherStones = data.results
            self.collectionOther.reloadData()
        }
        
    }
    
    private func localize() {
        closeButton.setTitle("", for: .normal)
        titleLable.text = "cam_title_match".localized
        subtitle.text = "cam_subtitle_match".localized
        matchText.text = "cam_match".localized
        matchText.adjustsFontSizeToFitWidth = true
        otherLable.text = "cam_other_match".localized
        upToText.text = "h_up_to".localized
    }
}

extension MatchViewController: MatchCellDelegate {
    func showCart(id: Int) {
        let vc = CartStoneViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        otherStones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath) as? MatchCell else {
            return UICollectionViewCell()
        }
        
        cell.titleTxt.text = otherStones[indexPath.row].stone.name
        cell.imgView.setupImgURL(url: otherStones[indexPath.row].stone.image)
        cell.priceTxt.text = "$\(otherStones[indexPath.row].stone.pricePerCaratFrom?.remove$() ?? "0") - $\(otherStones[indexPath.row].stone.pricePerCaratTo?.remove$() ?? "0") ct"
        cell.id = otherStones[indexPath.row].stone.id
        cell.delegate = self
        return cell
    }
}
