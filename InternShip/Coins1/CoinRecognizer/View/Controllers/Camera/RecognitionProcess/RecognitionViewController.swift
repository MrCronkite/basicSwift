

import UIKit

final class RecognitionViewController: UIViewController {
    
    var presenter: RecognitionPresenter?
    private var secondsRemaining: Int = 6
    
    @IBOutlet weak private var containerCoinView: UIView!
    @IBOutlet weak private var titleText: UILabel!
    @IBOutlet weak private var lableTimer: UILabel!
    @IBOutlet weak private var subviewLoader: UIView!
    @IBOutlet weak private var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var viewLoader: UIView!
    @IBOutlet weak private var imageLoader: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.startAnimation()
        presenter?.startTimer()
    }
    
    override func viewWillLayoutSubviews() {
        viewLoader.setupGradient(startColor: Asset.Color.startColor.color, endColor: Asset.Color.endColor.color)
    }
}

private extension RecognitionViewController {
    func setupView() {
        view.backgroundColor = Asset.Color.dark.color
        
        titleText.text = "recogn_proc".localized
        lableTimer.text = "six_sec".localized
        subviewLoader.addGradienBorder(colors: [Asset.Color.startColor.color,
                                                Asset.Color.endColor.color])
        subviewLoader.backgroundColor = .clear
        viewLoader.layer.cornerRadius = 12
        viewLoader.clipsToBounds = true
        viewLoader.backgroundColor = Asset.Color.orange.color
        containerCoinView.setupCoinAnimation(name: "coinloader")
    }
}

extension RecognitionViewController: RecognitionViewProtocol {
    func startAnimation() {
        UIView.animate(withDuration: 6, delay: 0, options: .curveLinear, animations: {
            self.rightConstraint.constant = 6
            self.subviewLoader.layoutIfNeeded()
        }, completion: { _ in
            self.rightConstraint.constant = 6
            self.subviewLoader.layoutIfNeeded()
        })
    }
    
    func updateTimer() {
        if secondsRemaining > 0 {
            lableTimer.text = "\(secondsRemaining) \("recognition_set".localized)"
            secondsRemaining -= 1
        } else {
            lableTimer.text = "0 \("recognition_set".localized)"
            presenter?.stopTimer()
        }
    }
}
