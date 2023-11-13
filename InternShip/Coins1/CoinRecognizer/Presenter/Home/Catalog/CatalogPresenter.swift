

import UIKit
import GoogleMobileAds
import Moya

protocol CatalogViewProtocol: AnyObject {
    func setupBanner(ad: GADBannerView)
    func reloadView()
}

protocol CatalogPresenter: AnyObject {
    var category: Int { get set }
    var tags: [TagsResult] { get set }
    var itemColors: [UIColor] { get set }
    var itemImages: [UIColor] { get set }
    
    init(view: CatalogViewProtocol,
         router: RouterProtocol,
         googleAd: GoogleAdMobService,
         storage: UserSettings,
         provider: MoyaProvider<CoinsService>)
     
    func tapOnClosse()
    func tapOnAllCoins()
    func loadBanner()
    func loadTags()
    func loadTag(by id: Int)
}
 
final class CatalogPresenterImpl: CatalogPresenter {
    weak var view: CatalogViewProtocol?
    var router: RouterProtocol?
    var googleAd: GoogleAdMobService?
    var storage: UserSettings?
    var category: Int = 0
    var provider: MoyaProvider<CoinsService>?
    var tags: [TagsResult] = []
    var itemColors: [UIColor] = []
    var itemImages: [UIColor] = []
    
    init(view: CatalogViewProtocol,
         router: RouterProtocol,
         googleAd: GoogleAdMobService,
         storage: UserSettings,
         provider: MoyaProvider<CoinsService>) {
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.storage = storage
        self.provider = provider
    }
    
    func loadTags() {
        provider?.request(.getTags, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let result = try response.map(Tags.self)
                    self.tags = result.results
                    self.setupItemsFolder()
                    self.view?.reloadView()
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func loadTag(by id: Int) {
        provider?.request(.getCoinByTag(tag: self.tags[id].id ), completion: { result in
            switch result {
            case .success(let response):
                print(String(data: response.data, encoding: .utf8) ?? "")
            case .failure(_): break
            }
        })
    }
    
    func setupItemsFolder() {
        itemImages = []
        itemColors = []
        for i in 0..<tags.count {
            let colorIndex = i % 6
            
            itemImages.append(R.Images.Collection.colorBG[colorIndex])
            itemColors.append(R.Images.Collection.colors[colorIndex])
        }
    }
    
    func loadBanner() {
        let isPremium = (storage?.premium(forKey: .keyPremium))!
        if !isPremium {
            guard let googleAd = googleAd else { return }
            view?.setupBanner(ad: googleAd.loadBaner())
        }
    }
    
    func tapOnAllCoins() {
        router?.goToAllCoins(tab: .collection, category: self.category)
    }
    
    func tapOnClosse() {
        router?.popToRoot()
    }
}
