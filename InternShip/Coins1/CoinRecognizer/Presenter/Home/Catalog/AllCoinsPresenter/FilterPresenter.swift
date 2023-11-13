

import UIKit

protocol FilterViewProtocol: AnyObject {
}

protocol FilterPresenter: AnyObject {
    var filterSettings: Filter? { get set }
    
    init(view: FilterViewProtocol, router: RouterProtocol)
    
    func closeView()
    func saveFilterSettings(settings: Filter)
}

final class FilterPresenterImpl: FilterPresenter {
    weak var view: FilterViewProtocol?
    var router: RouterProtocol?
    var filterSettings: Filter?
    
    init(view: FilterViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func saveFilterSettings(settings: Filter) {
        self.filterSettings = settings
    }
    
    func closeView() {
        router?.dismiss(view: view as! FilterViewController,
                        filter: filterSettings,
                        isAnimate: true,
                        name: "")
    }
}
