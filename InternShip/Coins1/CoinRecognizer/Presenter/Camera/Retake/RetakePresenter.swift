

import UIKit

protocol RetakeViewProtocol: AnyObject {
    
}

protocol RetakePresenter: AnyObject {
    var images: [UIImage] { get set }
    var category: Int { get set }
    var reference: Int { get set }
    
    init(view: RetakeViewProtocol, router: RouterProtocol, storage: UserSettings)
    
    func retake()
    func continueView()
    func closeView()
}

final class RetakePresenterImpl: RetakePresenter {
    weak var view: RetakeViewProtocol?
    var router: RouterProtocol
    var images: [UIImage] = []
    var category: Int = 0
    var reference: Int = 0
    var storage: UserSettings?
    
    init(view: RetakeViewProtocol, router: RouterProtocol, storage: UserSettings) {
        self.view = view
        self.router = router
        self.storage = storage
    }
    
    func closeView() {
        router.popToView(isAnimate: false)
        router.dismiss(view: view as! RetakeViewController,
                       filter: nil,
                       isAnimate: true,
                       name: "")
    }
    
    func retake() {
        router.dismiss(view: view as! RetakeViewController,
                       filter: nil,
                       isAnimate: true,
                       name: "")
    }
    
    func continueView() {
        guard let isPremium = storage?.premium(forKey: .keyPremium) else { return }
        if self.category == 0 {
            router.goToSelect(view: view as! RetakeViewController, images: images, reference: self.reference)
        } else {
            if !isPremium {
                router.goToAddCoin(view: view as! RetakeViewController,
                                   id: self.category,
                                   images: self.images,
                                   referecne: self.reference)
            } else {
                router.goToLoad(view: view as! RetakeViewController,
                                images: self.images,
                                id: self.category,
                                reference: self.reference)
            }
        }
    }
}

