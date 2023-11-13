

import UIKit
import GoogleMobileAds
import Moya

protocol FolderViewProtocol: AnyObject {
    func setupBanner(ad: GADBannerView)
    func hideShadowView()
    func reloadData()
}

protocol FolderPresenter: AnyObject {
    var collection: Collection? { get set }
    var isShowAlert: Bool { get set }
    
    init(view: FolderViewProtocol,
         router: RouterProtocol,
         googleAd: GoogleAdMobService,
         storage: UserSettings,
         providercollection: MoyaProvider<CollectionServices>,
         providerCoins: MoyaProvider<CoinsService>)
    
    func showAlert()
    func loadBanner()
    func setupView()
    func addNewCoinToCollection()
    func goBack()
    func deleteCollection()
    func deleteItem(id: Int)
    func deleteOrRename()
    func rename(name: String)
    func goToCoin(id: Int)
}

final class FolderPresenterImpl: FolderPresenter {
    weak var view: FolderViewProtocol?
    var router: RouterProtocol?
    var googleAd: GoogleAdMobService?
    var storage: UserSettings?
    var collection: Collection? = nil
    var providercollection: MoyaProvider<CollectionServices>?
    var isShowAlert: Bool = false
    var providerCoins: MoyaProvider<CoinsService>?
    
    init(view: FolderViewProtocol,
         router: RouterProtocol,
         googleAd: GoogleAdMobService,
         storage: UserSettings,
         providercollection: MoyaProvider<CollectionServices>,
         providerCoins: MoyaProvider<CoinsService>) {
        
        self.view = view
        self.router = router
        self.googleAd = googleAd
        self.storage = storage
        self.providercollection = providercollection
        self.providerCoins = providerCoins
    }
    
    func addNewCoinToCollection() {
        Activity.showAlertWithCatalogOrRecognizing { result in
            switch result {
            case "catalog": self.router?.goToCatalog(tab: .collection, category: self.collection?.id ?? 0)
            case "recognizing": self.router?.startCameraVC(tab: .camera,
                                                           isRecognition: true,
                                                           category: self.collection?.id ?? 0, reference: 0)
            default: break
            }
        }
    }
    
    func showAlert() {
        if isShowAlert {
            view?.hideShadowView()
        }
    }
    
    func loadBanner() {
        if let isPremium = storage?.premium(forKey: .keyPremium), !isPremium {
            guard let googleAd = googleAd else { return }
            view?.setupBanner(ad: googleAd.loadBaner())
        }
    }
    
    func rename(name: String) {
        providercollection?.request(.renameCollection(id: collection?.id ?? 0, name: name), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.collection?.name = name
                self.view?.reloadData()
            case .failure(_): break
            }
        })
    }
    
    func goToCoin(id: Int) {
        Activity.showActivity(view: view as! FolderViewController)
        providerCoins?.request(.getCoinForId(id: "\(collection?.items[id].reference.id ?? 0)"), completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let coins = try response.map(ReferenceCoins.self)
                    let result = ResultsCoins(id: coins.id,
                                              name: coins.name,
                                              reference: coins,
                                              chance: 0)
                    self.router?.goToCardCoin(tab: .collection, coins: [result], images: nil, category: 0)
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func deleteItem(id: Int) {
        Activity.showAlertWithDelete { [weak self] result in
            guard let self = self else { return }
            if result == "delete" {
                Activity.showActivity(view: view as! FolderViewController)
                providercollection?.request(.deleteCoins(id: self.collection?.items[id].id ?? 0), completion: { result in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        Activity.hideActivity()
                    }
                    switch result {
                    case .success(_):
                        self.collection?.items.remove(at: id)
                        self.view?.reloadData()
                    case .failure(_): break
                    }
                })
            }
        }
    }
    
    func deleteOrRename() {
        Activity.alertWithDeleteOrRename { [weak self] result in
            guard let self = self else { return }
            switch result {
            case "rename": self.router?.goToSetName(view: self.view as! FolderViewController)
            case "dellete":
                Activity.showAlertWithDelete { result in
                    if result == "delete" {
                        self.deleteCollection()
                    }
                }
            default: break
            }
         }
    }
    
    
    func deleteCollection() {
        Activity.showActivity(view: view as! FolderViewController)
        providercollection?.request(.deleteCategory(id: collection?.id ?? 0), completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case .success(_): self.goBack()
            case .failure(_): break
            }
        })
    }
    
    func setupView() {
        view?.reloadData()
    }
    
    func goBack() {
        router?.popToView(isAnimate: true)
    }
}
