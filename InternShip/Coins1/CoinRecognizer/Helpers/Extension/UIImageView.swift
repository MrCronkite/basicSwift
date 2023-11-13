

import UIKit
import Kingfisher

extension UIImageView {
    func image(url: String) {
        let activityInd = UIActivityIndicatorView()
        activityInd.center = CGPoint(x: self.frame.size.width  / 2,
                                     y: self.frame.size.height / 2)
        activityInd.color = Asset.Color.orange.color
        self.addSubview(activityInd)
        activityInd.startAnimating()
        self.kf.setImage(with: URL(string: url)) { result in
            activityInd.stopAnimating()
        }
    }
}
