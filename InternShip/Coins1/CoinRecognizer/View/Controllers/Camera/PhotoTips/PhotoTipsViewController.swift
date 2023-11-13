

import UIKit

final class PhotoTipsViewController: UIViewController {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var iconFirst: UIImageView!
    @IBOutlet weak var iconSecond: UIImageView!
    @IBOutlet weak var iconThird: UIImageView!
    @IBOutlet weak var lableFirst: UILabel!
    @IBOutlet weak var lableThird: UILabel!
    @IBOutlet weak var lableSecond: UILabel!
    @IBOutlet weak var goItButton: UIButton!
    
    
    @IBOutlet weak var darkImage: UIImageView!
    @IBOutlet weak var blurImage: UIImageView!
    @IBOutlet weak var multiImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var lineImage: UIImageView!
    @IBOutlet weak var multiLAble: UILabel!
    @IBOutlet weak var iconCrosThird: UIImageView!
    @IBOutlet weak var iconCrossSec: UIImageView!
    @IBOutlet weak var blurLable: UILabel!
    @IBOutlet weak var darkLable: UILabel!
    @IBOutlet weak var iconCross: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        localize()
    }
    
    @IBAction func close(_ sender: Any) {
        (sender as! UIButton).addTapEffect()
        dismiss(animated: true)
    }
}

private extension PhotoTipsViewController {
   func setupView() {
       view.backgroundColor = Asset.Color.dark.color
       mainImageView.image = Asset.Assets.mainTips.image
       iconFirst.image = Asset.Assets._1tips.image
       iconSecond.image = Asset.Assets._2tips.image
       iconThird.image = Asset.Assets._3tips.image
       
       goItButton.tintColor = .white
       goItButton.layer.cornerRadius = 27
       goItButton.backgroundColor = Asset.Color.orange.color
       darkImage.image = Asset.Assets.darkTips.image
       blurImage.image = Asset.Assets.blurTips.image
       multiImage.image = Asset.Assets.manyTips.image
       checkImage.image = Asset.Assets.checkTips.image
       iconCross.image = Asset.Assets.redCLose.image
       iconCrossSec.image = Asset.Assets.redCLose.image
       iconCrosThird.image = Asset.Assets.redCLose.image
       lineImage.image = Asset.Assets.line.image
    }
    
    func localize() {
        titleText.text = "Photo Tips"
        lableFirst.text = "Take a picture of each side of the coin"
        lableSecond.text = "The photo should be light and clear"
        lableThird.text = "There should be 1 coin in the picture"
        blurLable.text = "Blur"
        darkLable.text = "Dark"
        multiLAble.text = "Multiple"
        goItButton.setTitle("Got it!", for: .normal)
    }
}
