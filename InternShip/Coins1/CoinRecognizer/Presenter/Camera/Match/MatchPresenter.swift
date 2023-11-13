

import UIKit
import Moya

protocol MatchViewProtocol: AnyObject {
    func setupImages(images: [UIImage])
}

protocol MatchPresenter: AnyObject {
    var images: [UIImage] { get set }
    var coin: [ResultsCoins] { get set }
    var category: Int { get set }
    
    init(view: MatchViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, provider: MoyaProvider<ClassificationAPIService>)
    
    func popToRoot()
    func goToResult()
    func showImages()
    func watchAd()
}

final class MatchViewPresenterImpl: MatchPresenter {
    weak var view: MatchViewProtocol?
    var router: RouterProtocol?
    var images: [UIImage] = []
    var coin: [ResultsCoins] = []
    var googleAd: GoogleAdMobService?
    var provider: MoyaProvider<ClassificationAPIService>?
    var category: Int = 0
    
    init(view: MatchViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, provider: MoyaProvider<ClassificationAPIService>) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.provider = provider
    }
    
    func watchAd() {
        googleAd?.showRewardInter(view: view as! MatchViewController)
        
        googleAd?.adViewedAction = { [weak self] in
            guard let self = self else { return }
            self.router?.dismiss(view: self.view as! MatchViewController,
                                 filter: nil,
                                 isAnimate: false,
                                 name: "")
            self.router?.goToCardCoin(tab: .camera,
                                      coins: coin,
                                      images: self.images,
                                      category: self.category)
        }
    }
    
    func showImages() {
        view?.setupImages(images: self.images)
    }
    
    func goToResult() {
        router?.goToPremium(view: view as! MatchViewController)
    }
    
    func popToRoot() {
        router?.popToView(isAnimate: false)
        router?.dismiss(view: self.view as! MatchViewController,
                            filter: nil,
                            isAnimate: true,
                            name: "")
    }
}
