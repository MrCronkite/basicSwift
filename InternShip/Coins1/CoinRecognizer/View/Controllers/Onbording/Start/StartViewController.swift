

import UIKit

final class StartViewController: UIViewController {
    
    var presenter: StartPresenter?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        mainView.setupCoinAnimation(name: "coinloader")
        UIApplication.shared.statusBarStyle = .lightContent
        
        presenter?.requestDataPermission()
    }
}

private extension StartViewController {
    func setupView() {
        view.backgroundColor = Asset.Color.dark.color
        titleText.text = "Coin Identifier"
        mainView.backgroundColor = .clear
    }
}

extension StartViewController: StartViewProtocol {
    
}
