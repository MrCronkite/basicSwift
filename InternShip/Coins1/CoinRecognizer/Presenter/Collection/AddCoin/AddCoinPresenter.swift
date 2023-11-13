

import UIKit

protocol AddCoinViewProtocol: AnyObject {
}

protocol AddCoinPresenter: AnyObject {
    var id: Int { get set }
    var images: [UIImage] { get set }
    var reference: Int { get set }
    
    init(view: AddCoinViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService)
    
    func popToRoot()
    func loadGoogleAd()
    func goToPremium()
}

final class AddCoinPresenterImpl: AddCoinPresenter {
    weak var view: AddCoinViewProtocol?
    var router: RouterProtocol?
    var googleAd: GoogleAdMobService?
    var id: Int = 0
    var images: [UIImage] = []
    var reference: Int = 0
    
    init(view: AddCoinViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
    }
    
    func loadGoogleAd() {
        googleAd?.showRewardInter(view: view as! AddCoinViewController)
        
        googleAd?.adViewedAction = { [weak self] in
            guard let self = self else { return }
            self.router?.goToLoad(view: self.view as! AddCoinViewController,
                                  images: self.images,
                                  id: self.id,
                                  reference: self.reference)
        }
    }
    
    func goToPremium() {
        router?.goToPremium(view: view as! AddCoinViewController)
    }
    
    func popToRoot() {
        router?.dismiss(view: view as! UIViewController,
                        filter: nil,
                        isAnimate: false,
                        name: "")
    }
}
