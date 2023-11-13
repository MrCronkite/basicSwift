

import UIKit
import GoogleMobileAds
import Moya

enum Category {
    case collection
    case history
    case favorites
}

protocol CollectionViewProtocol: AnyObject {
    func succes()
    func updateCollection()
    func updateHistory()
    func updateFavorites()
    func updateFolder()
    func hideButton()
}

protocol CollectionPresenter: AnyObject {
    var coins: [String] { get set }
    var selectedCategory: Category { get set }
    var itemColors: [UIColor] { get set }
    var itemImages: [UIImage] { get set }
    var historyCoins: [RecognitionCoinsResult] { get set }
    var whislist: [WishlistResult] { get set }
    var collections: [ResultCollectionList] { get set }
    var sotorage: UserSettings? { get set }
    
    init(view: CollectionViewProtocol,
         router: RouterProtocol,
         providerClassification: MoyaProvider<ClassificationAPIService>,
         providerCoins: MoyaProvider<CoinsService>,
         providerCollection: MoyaProvider<CollectionServices>,
         storage: UserSettings)
    
    func setupItemsFolder()
    func tapOnTheCamera()
    func tapOnTheSettings()
    func tapGoPremium()
    func loadCollection()
    func getCollection(id: Int)
    func createCollection(name: String)
    func loadHistory()
    func getHistoryInId(id: Int)
    func loadFavorites()
    func getWishlistInId(id: Int)
    func tapOnTheSetNameView()
}

final class CollectionPresenterImpl: CollectionPresenter {
    weak var view: CollectionViewProtocol?
    var router: RouterProtocol?
    var coins: [String] = []
    var selectedCategory: Category = .collection
    var itemColors: [UIColor] = []
    var itemImages: [UIImage] = []
    var providerClassification: MoyaProvider<ClassificationAPIService>?
    var providerCoins: MoyaProvider<CoinsService>?
    var providerCollection: MoyaProvider<CollectionServices>?
    var historyCoins: [RecognitionCoinsResult] = []
    var whislist: [WishlistResult] = []
    var collections: [ResultCollectionList] = []
    var sotorage: UserSettings?
    
    init(view: CollectionViewProtocol,
         router: RouterProtocol,
         providerClassification: MoyaProvider<ClassificationAPIService>,
         providerCoins: MoyaProvider<CoinsService>,
         providerCollection: MoyaProvider<CollectionServices>,
         storage: UserSettings) {
        
        self.view = view
        self.router = router
        self.providerClassification = providerClassification
        self.providerCoins = providerCoins
        self.providerCollection = providerCollection
        self.sotorage = storage
    }
    
    func setupItemsFolder() {
        itemImages = []
        itemColors = []
        for i in 0..<collections.count {
            let colorIndex = i % 6
            
            itemImages.append(R.Images.Collection.images[colorIndex])
            itemColors.append(R.Images.Collection.colors[colorIndex])
        }
    }
    
    func loadCollection() {
        Activity.showActivity(view: view as! CollectionViewController)
        providerCollection?.request(.getCollectionList, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let collection = try response.map(CollectionList.self)
                    self.collections = []
                    self.selectedCategory = .collection
                    collection.results.forEach { item in
                        self.collections.insert(item, at: 0)
                    }
                    self.collections.append(ResultCollectionList(id: 0,
                                                                 createdAt: "",
                                                                 name: "",
                                                                 itemsCount: 0,
                                                                 user: 0))
                    self.setupItemsFolder()
                    self.view?.updateCollection()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func getCollection(id: Int) {
        Activity.showActivity(view: view as! CollectionViewController)
        providerCollection?.request(.readCollection(id: self.collections[id].id), completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let item = try response.map(Collection.self)
                    self.router?.goToFolder(tab: .collection,
                                            collection: item,
                                            isShowAlert: false,
                                            isAnimate: true)
                    self.view?.hideButton()
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func createCollection(name: String) {
        providerCollection?.request(.createCollectionCategory(name: name), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.loadCollection()
            case .failure(_): break
            }
        })
    }
    
    func loadFavorites() {
        Activity.showActivity(view: view as! CollectionViewController)
        providerCoins?.request(.getWishlist, completion: { [weak self] result in
            guard let self = self else { return }
            Activity.hideActivity()
            switch result {
            case let .success(response):
                do {
                    let whislist = try response.map(Wishlist.self)
                    self.whislist = whislist.results
                    self.selectedCategory = .favorites
                    self.view?.updateFavorites()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func loadHistory() {
        Activity.showActivity(view: view as! CollectionViewController)
        providerClassification?.request(.getHistory, completion: { [weak self] result in
            guard let self = self else { return }
            Activity.hideActivity()
            switch result {
            case let .success(response):
                do {
                    let coins = try response.map(RecognitionCoins.self)
                    self.historyCoins = coins.results
                    self.selectedCategory = .history
                    self.view?.updateHistory()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getHistoryInId(id: Int) {
        Activity.showActivity(view: view as! CollectionViewController)
        providerClassification?.request(.getHistoryId(id: "\(historyCoins[id].id)"), completion: { [weak self] result in
            guard let self = self else { return }
            Activity.hideActivity()
            switch result {
            case let .success(response):
                do {
                    let coins = try response.map(Coin.self)
                    self.router?.goToCardCoin(tab: .collection, coins: coins.results, images: nil, category: 0)
                    self.view?.hideButton()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getWishlistInId(id: Int) {
        Activity.showActivity(view: view as! CollectionViewController)
        providerCoins?.request(.getCoinForId(id: "\(self.whislist[id].reference.id)"), completion: { [weak self] result in
            guard let self = self else { return }
            Activity.hideActivity()
            switch result {
            case let .success(response):
                do {
                    let coins = try response.map(ReferenceCoins.self)
                    let result = ResultsCoins(id: coins.id,
                                              name: coins.name,
                                              reference: coins,
                                              chance: 0)
                    self.router?.goToCardCoin(tab: .collection, coins: [result], images: nil, category: 0)
                    self.view?.hideButton()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func tapGoPremium() {
        router?.goToPremium(view: view as! CollectionViewController)
    }
    
    func tapOnTheSettings() {
        router?.goToSettings(tab: .collection)
    }
    
    func tapOnTheCamera() {
        router?.startCameraVC(tab: .collection, isRecognition: true, category: 0, reference: 0)
    }
    
    func tapOnTheSetNameView() {
        router?.goToSetName(view: view as! CollectionViewController)
    }
}
