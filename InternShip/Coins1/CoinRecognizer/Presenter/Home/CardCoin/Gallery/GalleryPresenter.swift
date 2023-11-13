

import UIKit

protocol GalleryViewProtocol: AnyObject {
    
}

protocol GalleryPresenter: AnyObject {
    var photos: [Photo?] { get set }
    init(view: GalleryViewProtocol, router: RouterProtocol)
    
    func popToView()
}

final class GalleryPresenterImpl: GalleryPresenter {
    weak var view: GalleryViewProtocol?
    var router: RouterProtocol?
    var photos: [Photo?] = []
    
    init(view: GalleryViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func popToView() {
        router?.popToView(isAnimate: true)
    }
}
