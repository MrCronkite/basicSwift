

import UIKit

protocol NoMatchViewProtocol: AnyObject {
    func setupImage()
}

protocol NoMatchPresenter: AnyObject {
    var images: [UIImage] { get set }
    
    init(view: NoMatchViewProtocol, router: RouterProtocol)
    
   func setupView()
   func popToView()
}

final class NoMatchPresenterImpl: NoMatchPresenter {
    weak var view: NoMatchViewProtocol?
    var router: RouterProtocol?
    var images: [UIImage] = []
    
    init(view: NoMatchViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func setupView() {
        view?.setupImage()
    }
    
    func popToView() {
        router?.popToView(isAnimate: true)
    }
}
