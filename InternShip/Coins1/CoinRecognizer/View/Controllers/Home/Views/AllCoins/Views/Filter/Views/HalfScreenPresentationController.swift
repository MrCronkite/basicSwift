

import UIKit

class HalfScreenPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        let screenBounds = UIScreen.main.bounds
        return CGRect(x: 0, y: screenBounds.height - 600, width: containerView.bounds.width, height: 700)
    }
}
