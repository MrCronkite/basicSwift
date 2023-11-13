

import UIKit
import Moya

protocol LoadViewProtocol: AnyObject {
    
}

protocol LoadPresenter: AnyObject {
    var images: [UIImage] { get set }
    var id: Int { get set }
    var reference: Int { get set }
    var item: Collection? { get set }
    var idCategory: Int { get set }
    
    init(view: LoadViewProtocol, router: RouterProtocol, provider: MoyaProvider<CollectionServices>)
    
    func goToFolder()
    func getCollection(id: Int, isDismiss: Bool)
    func setupImageForCoin(id: Int)
}

final class LoadPresenterImpl: LoadPresenter {
    weak var view: LoadViewProtocol?
    var router: RouterProtocol?
    var provider: MoyaProvider<CollectionServices>?
    var images: [UIImage] = []
    var id: Int = 0
    var reference: Int = 0
    var idCategory: Int = 0
    var item: Collection? = nil
    
    init(view: LoadViewProtocol, router: RouterProtocol, provider: MoyaProvider<CollectionServices>) {
        self.view = view
        self.router = router
        self.provider = provider
    }
    
    func goToFolder() {
        provider?.request(.createCoinsCollection(reference: self.reference, request: 0, category: self.id), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let result = try response.map(CoinsResponse.self)
                    self.idCategory = result.category
                    self.getCollection(id: self.idCategory, isDismiss: false)
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func getCollection(id: Int, isDismiss: Bool) {
        provider?.request(.readCollection(id: id), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                do {
                    let item = try response.map(Collection.self)
                    self.item = item
                    if isDismiss {
                        self.router?.dismiss(view: self.view as! LoadViewController, filter: nil, isAnimate: false, name: "")
                    } else {
                        self.setupImageForCoin(id: self.item?.items.first!.id ?? 0)
                    }
                } catch {
                    print(String(data: response.data, encoding: .utf8) ?? "")
                }
            case .failure(_): break
            }
        })
    }
    
    func setupImageForCoin(id: Int) {
        provider?.request(.uploadImageForId(id: id, image: self.images.first!), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.getCollection(id: self.idCategory, isDismiss: true)
                self.setupReverseImage(id: id)
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
    
    func setupReverseImage(id: Int) {
        provider?.request(.uploadImageForId(id: id, image: self.images.last!), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_): break
            case let .failure(error):
                print(error.localizedDescription)
            }
        })
    }
}
