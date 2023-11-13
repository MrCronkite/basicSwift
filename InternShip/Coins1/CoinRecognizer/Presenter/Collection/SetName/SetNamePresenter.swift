

import UIKit

protocol SetNameViewProtocol: AnyObject {
    func succes()
}

protocol SetNamePresenter {
    var textName: String? { get set }
    
    init(view: SetNameViewProtocol, router: RouterProtocol)
    
    func saveName()
    func closeView()
}

final class SetNamePresenterImpl: SetNamePresenter {
    weak var view: SetNameViewProtocol?
    var router: RouterProtocol?
    var textName: String?
    
    init(view: SetNameViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func saveName() {
        view?.succes()
    }
    
    func closeView() {
        router?.dismiss(view: view as! SetNameViewController,
                        filter: nil,
                        isAnimate: true,
                        name: textName ?? "")
    }
}
