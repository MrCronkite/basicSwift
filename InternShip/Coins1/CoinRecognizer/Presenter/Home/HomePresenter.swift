

import UIKit
import GoogleMobileAds
import Moya

protocol HomeViewProtocol: AnyObject {
    func setupArticles()
    func setupBanner(ad: GADBannerView)
    func deleteBaner()
    func enabledView()
    func enableCollection() 
}

protocol HomePresenter: AnyObject {
    var articles: [ArticlesResult] { get set }
    
    init(view: HomeViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, storage: UserSettings, provider: MoyaProvider<ArticleService> )
    
    func tapOnTheCamera()
    func tapOnTheSettings()
    func tapOnTheAllCoins()
    func tapOnTheCatalog()
    func tapOnTheChat()
    func tapOnTheArticles(id: Int)
    func goToPremium()
    func loadBanner()
    func loadArticles()
}

final class HomePresenterImpl: HomePresenter {
    weak var view: HomeViewProtocol?
    var router: RouterProtocol?
    var googleAd: GoogleAdMobService?
    var storage: UserSettings?
    var provider: MoyaProvider<ArticleService>?
    var articles: [ArticlesResult] = []
    let indicatorType = IndicatorType()
    
    required init(view: HomeViewProtocol, router: RouterProtocol, googleAd: GoogleAdMobService, storage: UserSettings, provider: MoyaProvider<ArticleService>) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.storage = storage
        self.provider = provider
    }
    
    func loadBanner() {
        let isPremium = (storage?.premium(forKey: .keyPremium))!
        if !isPremium {
            guard let googleAd = googleAd else { return }
            view?.setupBanner(ad: googleAd.loadBaner())
        } else {
            view?.deleteBaner()
        }
    }
    
    func loadArticles() {
        Activity.showActivity(view: view as! HomeViewController)
        provider?.request(.getArticlesCoins, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let articles = try response.map(Articles.self)
                    self.articles = articles.results
                    view?.setupArticles()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func tapOnTheArticles(id: Int) {
        if Activity.checkInthernet(view: view as! HomeViewController) {
            indicatorType.addLoading(view: view as! HomeViewController)
            provider?.request(.getArticleForId(id:  "\(self.articles[id].id)"), completion: { [weak self] result in
                guard let self = self else { return }
                indicatorType.deleleLoader()
                switch result {
                case let .success(response):
                    do {
                        let article = try response.map(ArticleForCoins.self)
                        self.router?.goToArticles(article: article)
                        self.view?.enabledView()
                    } catch {
                        print( String(data: response.data, encoding: .utf8) ?? "")
                    }
                case .failure(_): break
                }
            })
        } else {
            view?.enableCollection()
        }
    }
    
    func tapOnTheCatalog() {
        router?.goToCatalog(tab: .home, category: 0)
    }
    
    func tapOnTheSettings() {
        router?.goToSettings(tab: .home)
    }
    
    func tapOnTheAllCoins() {
        router?.goToAllCoins(tab: .home, category: 0)
    }
    
    func goToPremium() {
        router?.goToPremium(view: view as! HomeViewController)
    }
    
    func tapOnTheCamera() {
        router?.startCameraVC(tab: .home, isRecognition: true, category: 0, reference: 0)
    }
    
    func tapOnTheChat() {
        router?.goToChat()
    }
}
