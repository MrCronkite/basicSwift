

import UIKit
import Moya

protocol SelectViewProtocol: AnyObject {
    func reloadData()
}

protocol SelectPresenter: AnyObject {
    var coins: [String] { get set }
    var images: [UIImage] { get set }
    var itemColors: [UIColor] { get set }
    var itemImages: [UIImage] { get set }
    var imagesCoins: [UIImage] { get set }
    var collections: [ResultCollectionList] { get set }
    var reference: Int { get set }
    
    func loadCollection()
    func closeView()
    func setupItemsFolder()
    func tapOnTheFolderView(index: Int)
    func tapOnTheSetNameView()
    func createCollection(name: String)
}

final class SelectPresenterImpl: SelectPresenter {
    weak var view: SelectViewProtocol?
    var router: RouterProtocol?
    var coins: [String] = []
    var itemColors: [UIColor] = []
    var itemImages: [UIImage] = []
    var imagesCoins: [UIImage] = []
    var images: [UIImage] = []
    var collections: [ResultCollectionList] = []
    var providerCollection: MoyaProvider<CollectionServices>?
    var reference: Int = 0
    var storage: UserSettings?
    
    init(view: SelectViewProtocol, router: RouterProtocol, providerCollection: MoyaProvider<CollectionServices>, storage: UserSettings) {
        self.view = view
        self.router = router
        self.providerCollection = providerCollection
        self.storage = storage
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
        Activity.showActivity(view: view as! SelectCollectionViewController)
        providerCollection?.request(.getCollectionList, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Activity.hideActivity()
            }
            switch result {
            case let .success(response):
                do {
                    let collection = try response.map(CollectionList.self)
                    self.collections = []
                    collection.results.forEach { item in
                        self.collections.insert(item, at: 0)
                    }
                    self.collections.append(ResultCollectionList(id: 0,
                                                                 createdAt: "",
                                                                 name: "",
                                                                 itemsCount: 0,
                                                                 user: 0))
                    self.setupItemsFolder()
                    self.view?.reloadData()
                } catch {
                    print( String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func createCollection(name: String) {
        providerCollection?.request(.createCollectionCategory(name: name), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let result = try response.map(CreateColletion.self)
                    self.loadCollection()
                } catch { 
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func tapOnTheSetNameView() {
        router?.goToSetName(view: view as! SelectCollectionViewController)
    }
    
    func tapOnTheFolderView(index: Int) {
        if !(storage?.premium(forKey: .keyPremium) ?? true) {
            router?.goToAddCoin(view: view as! SelectCollectionViewController, id: collections[index].id, images: self.images, referecne: self.reference)
        } else {
            router?.goToLoad(view: view as! SelectCollectionViewController,
                             images: self.images,
                             id: self.collections[index].id,
                             reference: self.reference)
        }
    }
    
    func closeView() {
        router?.dismiss(view: view as! SelectCollectionViewController, filter: nil, isAnimate: true, name: "")
    }
}
