

import UIKit

final class LoadViewController: UIViewController {
    
    var presenter: LoadPresenter?
    
    @IBOutlet weak private var containerAnime: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        containerAnime.setupCoinAnimation(name: "coinloader")
        presenter?.goToFolder()
    }
}

private extension LoadViewController {
    func setupView() {
        view.backgroundColor = Asset.Color.dark.color
    }
}

extension LoadViewController: LoadViewProtocol {
}

