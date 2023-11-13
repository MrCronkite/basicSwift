

import UIKit
import GoogleMobileAds
import Moya

protocol ArticlesViewProtocol: AnyObject {
    func succes()
    func setupBanner(ad: GADBannerView)
}

protocol ArticlesPresenter: AnyObject {
    var article: ArticleForCoins? { get set }
    init(view: ArticlesViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, settings: UserSettings)
    
    func setupArticleForView()
    func popToRoot()
    func loadBanner()
}

final class ArticlesPresenterImpl: ArticlesPresenter {
    weak var view: ArticlesViewProtocol?
    var router: RouterProtocol
    var googleAd: GoogleAdMobService?
    var settings: UserSettings?
    var article: ArticleForCoins? = nil
    
    init(view: ArticlesViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, settings: UserSettings) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.settings = settings
    }
    
    func setupArticleForView() {
        if article != nil {
            view?.succes()
        }
    }
    
    func loadBanner() {
        let isPremium = (settings?.premium(forKey: .keyPremium))!
        if !isPremium {
            guard let googleAd = googleAd else { return }
            view?.setupBanner(ad: googleAd.loadBaner())
        }
    }
    
    func popToRoot() {
        router.popToView(isAnimate: true)
    }
}
