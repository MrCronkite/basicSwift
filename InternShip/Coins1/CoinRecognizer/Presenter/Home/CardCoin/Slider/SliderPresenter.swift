

import UIKit

protocol SliderCoinView: AnyObject {
    
}

protocol SliderPresenter: AnyObject {
    var coins: [ResultsCoins] { get set }
    var images: [UIImage]? { get set }
    var slides: [CardCoinViewController] { get set }
    var category: Int { get set }
    
    init(view: SliderCoinView, router: RouterProtocol, assembly: AssemblyBuilder)
    
    func setupSlides()
    func popToView()
}

final class SliderPresenterImpl: SliderPresenter {
    weak var view: SliderCoinView?
    var router: RouterProtocol?
    var coins: [ResultsCoins] = []
    var images: [UIImage]? = nil
    var assembly: AssemblyBuilder?
    var slides: [CardCoinViewController] = []
    var category: Int = 0
    
    init(view: SliderCoinView, router: RouterProtocol, assembly: AssemblyBuilder) {
        self.view = view
        self.router = router
        self.assembly = assembly
    }
    
    func popToView() {
        router?.popToRoot()
    }
    
    func setupSlides() {
        for coin in coins {
            guard let vc = assembly?.createCardCoinModule(router: router!) as? CardCoinViewController else { return }
            vc.presenter?.coins = [coin]
            vc.presenter?.images = self.images
            vc.presenter?.category = self.category
            slides.append(vc)
        }
    }
    
}
