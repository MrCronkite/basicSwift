

import UIKit
import Moya
import StoreKit

protocol CardCoinViewProtocol: AnyObject {
    func setupImages(images: [UIImage]?)
    func setupDataView()
}

protocol CardCoinPresenter: AnyObject {
    var images: [UIImage]? { get set }
    var coins: [ResultsCoins] { get set }
    var category: Int { get set }
    
    init(view: CardCoinViewProtocol,
         router: RouterProtocol,
         providerCoins: MoyaProvider<CoinsService>)
    
    func popToRoot()
    func showImages()
    func setupFavorite()
    func addCollection()
    func goToDataForView()
    func goToGallery()
}

final class CardCoinPresenterImpl: CardCoinPresenter {
    weak var view: CardCoinViewProtocol?
    var router: RouterProtocol?
    var images: [UIImage]? = nil
    var coins: [ResultsCoins] = []
    var providerCoins: MoyaProvider<CoinsService>?
    var category: Int = 0
    
    init(view: CardCoinViewProtocol,
         router: RouterProtocol,
         providerCoins: MoyaProvider<CoinsService>) {
        self.view = view
        self.router = router
        self.providerCoins = providerCoins
    }
    
    func addCollection() {
        if let images = self.images {
            if self.category != 0 {
                router?.goToAddCoin(view: view as! CardCoinViewController, id: self.category, images: images, referecne: coins.first?.reference.id ?? 0)
            } else {
                router?.goToSelect(view: view as! CardCoinViewController, images: images, reference: coins.first?.reference.id ?? 0)
            }
        } else {
            if self.category != 0 {
                router?.startCameraVC(tab: .camera,
                                      isRecognition: false,
                                      category: self.category,
                                      reference: coins.first?.reference.id ?? 0)
            } else {
                router?.startCameraVC(tab: .camera,
                                      isRecognition: false,
                                      category: 0,
                                      reference: coins.first?.reference.id ?? 0)
            }
        }
    }
    
    func goToDataForView() {
        view?.setupDataView()
    }
    
    func showImages() {
        view?.setupImages(images: images)
    }
    
    func goToGallery() {
        if coins.first?.reference.photos.count != 0 {
            router?.goToGallery(photos: coins.first?.reference.photos ?? [])
        }
    }
    
    func setupFavorite() {
        guard let isFavorite = coins.first?.reference.isFavorite else { return }
        if isFavorite {
            Activity.showActivity(view: view as! CardCoinViewController)
            providerCoins?.request(.deleteFavorite(id: (coins.first?.reference.id)!), completion: { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    Activity.hideActivity()
                }
                switch result {
                case .success(_): break
                case .failure(_): break
                }
            })
        } else {
            Activity.showActivity(view: view as! CardCoinViewController)
            providerCoins?.request(.postGoWishlist(id: (coins.first?.reference.id)!), completion: { result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    Activity.hideActivity()
                }
                switch result {
                case .success(_): break
                case .failure(_): break
                }
            })
        }
    }
    
    func popToRoot() {
        router?.popToRoot()
    }
}
