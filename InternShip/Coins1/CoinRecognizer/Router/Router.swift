

import UIKit

enum Tabs: Int, CaseIterable {
    case home
    case camera
    case collection
}

enum InitalVC {
    case start
    case onbording
    case tabBar
}

protocol Router {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilder? { get set }
}

protocol RouterProtocol: Router {
    func setupInitialViewController(initialView: InitalVC)
    func startController() -> UIViewController
    func goToOnbording() -> UIViewController
    func goToTabBarControoler() -> UITabBarController
    func startCameraVC(tab: Tabs, isRecognition: Bool, category: Int, reference: Int)
    func goToSettings(tab: Tabs)
    func goToAllCoins(tab: Tabs, category: Int)
    func goToCatalog(tab: Tabs, category: Int)
    func goToFilter(filter: Filter?)
    func goToSetName(view: UIViewController)
    func goToFolder(tab: Tabs, collection: Collection?, isShowAlert: Bool, isAnimate: Bool)
    func goToChat()
    func goToCardCoin(tab: Tabs, coins: [ResultsCoins], images: [UIImage]?, category: Int)
    func goToRecognition(images: [UIImage], category: Int)
    func goToMatch(images: [UIImage], coin: [ResultsCoins], category: Int)
    func goToPremium(view: UIViewController)
    func goToLoad(view: UIViewController, images: [UIImage], id: Int, reference: Int)
    func goToAddCoin(view: UIViewController, id: Int, images: [UIImage], referecne: Int)
    func goToArticles(article: ArticleForCoins)
    func goToRetake(images: [UIImage], category: Int, reference: Int)
    func goToNoMatch(images: [UIImage])
    func goToSelect(view: UIViewController, images: [UIImage], reference: Int)
    func openPhotoLibrary()
    func goToGallery(photos: [Photo?])
    func popToView(isAnimate: Bool)
    func popToRoot()
    func dismiss(view: UIViewController, filter: Filter?, isAnimate: Bool, name: String)
}

final class RouterImpl: NSObject, RouterProtocol {
    var controllers: [UINavigationController] = []
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilder?
    var window: UIWindow?
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilder,
         window: UIWindow?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
        self.window = window
    }
    
    private func setNavigation(for tab: Tabs) {
        switch tab {
        case .home: navigationController = controllers.first
        case .collection: navigationController = controllers.last
        case .camera: break
        }
    }
    
    private func presentViewController(_ viewController: UIViewController, style: UIModalPresentationStyle = .custom, preferredContentSize: CGSize? = nil) {
        viewController.modalPresentationStyle = style
        viewController.transitioningDelegate = self
        if let size = preferredContentSize {
            viewController.preferredContentSize = size
        }
        navigationController?.viewControllers.last?.present(viewController, animated: true)
    }
    
    private func initialViewController() -> [UINavigationController] {
        for tab in Tabs.allCases {
            let controller = UINavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: R.Strings.TabBar.title(for: tab),
                                                 image: R.Images.TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            navigationController = controller
            controllers.append(navigationController!)
        }
        return controllers
    }
    
    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .home:
            guard let homeVC = assemblyBuilder?.createHomeModule(router: self) else { return UIViewController() }
            return homeVC
        case .collection:
            guard let collectionVC = assemblyBuilder?.createCollectionModule(router: self) else { return UIViewController() }
            return collectionVC
        case .camera: return UIViewController()
        }
    }
}

extension RouterImpl {
    func setupInitialViewController(initialView: InitalVC) {
        switch initialView {
        case .start:
            let startVC = startController()
            self.window?.rootViewController = startVC
            AnaliticsService.shared.logEvent(name: Events.view_start_loading)
        case .onbording:
            let onbordingVC = goToOnbording()
            self.window?.rootViewController = nil
            self.window?.rootViewController = onbordingVC
            AnaliticsService.shared.logEvent(name: Events.view_onbording)
        case .tabBar:
            if !(self.window?.rootViewController is TabBarController) {
                let tabBarVC = goToTabBarControoler()
                self.window?.rootViewController = tabBarVC
                AnaliticsService.shared.logEvent(name: Events.open_home_view)
            }
        }
    }
    
    func startController() -> UIViewController {
        guard let vc = assemblyBuilder?.createStartModule(router: self) else { return UIViewController() }
        return vc
    }
    
    func goToOnbording() -> UIViewController {
        let vc = OnbordingViewController()
        vc.assembly = assemblyBuilder
        vc.router = self
        return vc
    }
    
    func goToTabBarControoler() -> UITabBarController {
        let tabBarController = TabBarController()
        tabBarController.setViewControllers(self.initialViewController(), animated: true)
        return tabBarController
    }
    
    func goToPremium(view: UIViewController) {
        guard let vc = assemblyBuilder?.createPremiumModule(router: self) else { return }
        vc.modalPresentationStyle = .fullScreen
        view.present(vc, animated: true)
        
        AnaliticsService.shared.logEvent(name: Events.open_premium)
    }
    
    func startCameraVC(tab: Tabs, isRecognition: Bool, category: Int, reference: Int) {
        setNavigation(for: tab)
        if let navigationController = navigationController {
            guard let cameraVC = assemblyBuilder?.createCameraModule(router: self) as? CameraViewController else { return }
            cameraVC.presenter?.isRecogntion = isRecognition
            cameraVC.presenter?.category = category
            cameraVC.presenter?.reference = reference
            navigationController.pushViewController(cameraVC, animated: true)
        }
        
        AnaliticsService.shared.logEvent(name: Events.open_camera_view)
    }
    
    func goToRetake(images: [UIImage], category: Int, reference: Int) {
        if let navigationController = navigationController {
            if let vc = assemblyBuilder?.createRetakeModule(router: self) as? RetakeViewController {
                vc.presenter?.images = images
                vc.presenter?.category = category
                vc.presenter?.reference = reference
                vc.isModalInPresentation = true
                navigationController.viewControllers.last?.present(vc, animated: true)
            }
        }
    }
    
    func goToNoMatch(images: [UIImage]) {
        if let navigationController = navigationController {
            if let vc = assemblyBuilder?.createNoMatchModule(router: self) as? NoMatchViewController {
                vc.presenter?.images = images
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
    
    func goToSettings(tab: Tabs) {
        setNavigation(for: tab)
        if let navigationController = navigationController {
        guard let settingsVC = assemblyBuilder?.createSettingsModule(router: self) else { return }
            navigationController.pushViewController(settingsVC, animated: true)
        }
    }
    
    func goToCatalog(tab: Tabs, category: Int) {
        switch tab {
        case .home: navigationController = controllers.first ?? navigationController
        case .camera: break
        case .collection: navigationController = controllers.last ?? navigationController
        }
        
        if let navigationController = navigationController {
            guard let catalogVC = assemblyBuilder?.createCatalogModule(router: self) as? CatalogViewController else { return }
            catalogVC.presenter?.category = category
            navigationController.pushViewController(catalogVC, animated: true)
        }
        
        AnaliticsService.shared.logEvent(name: Events.open_catalog)
    }
    
    func goToAllCoins(tab: Tabs, category: Int) {
        if tab == .home {
            navigationController = controllers.first ?? navigationController
        }
        if let navigationController = navigationController {
            guard let allCoinVC = assemblyBuilder?.createAllCoinsModule(router: self) as? AllCoinsViewController else { return }
            allCoinVC.presenter?.category = category
            navigationController.pushViewController(allCoinVC, animated: true)
        }
        
        AnaliticsService.shared.logEvent(name: Events.open_allcoins)
    }
    
    func goToGallery(photos: [Photo?]) {
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createGalleryModule(router: self) as? GalleryViewController else { return }
            vc.presenter?.photos = photos
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func goToSelect(view: UIViewController, images: [UIImage], reference: Int) {
        guard let vc = assemblyBuilder?.createSelectModule(router: self) as? SelectCollectionViewController else { return }
        vc.presenter?.images = images
        vc.presenter?.reference = reference
        vc.isModalInPresentation = true
        view.present(vc, animated: true)
    }
    
    func goToFilter(filter: Filter?) {
        if let vc = assemblyBuilder?.createFilterModule(router: self) as? FilterViewController {
            vc.presenter?.filterSettings = filter
            presentViewController(vc, style: .custom, preferredContentSize: CGSize(width: UIScreen.main.bounds.width, height: 700))
        }
    }
    
    func goToSetName(view: UIViewController) {
        guard let vc = assemblyBuilder?.createSetNameModule(router: self) else { return }
        vc.isModalInPresentation = true
        view.present(vc, animated: true)
    }
    
    func goToFolder(tab: Tabs, collection: Collection?, isShowAlert: Bool, isAnimate: Bool) {
        setNavigation(for: tab)
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createFolderModule(router: self) as? FolderViewController  else { return }
            vc.presenter?.collection = collection
            vc.presenter?.isShowAlert = isShowAlert
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func goToLoad(view: UIViewController, images: [UIImage], id: Int, reference: Int) {
        guard let vc = assemblyBuilder?.createLoadModule(router: self) as? LoadViewController else { return }
        vc.presenter?.images = images
        vc.presenter?.id = id
        vc.presenter?.reference = reference
        vc.modalPresentationStyle = .fullScreen
        view.present(vc, animated: true)
    }
    
    func goToChat() {
        navigationController = controllers.first ?? navigationController
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createChatModule(router: self) else { return }
            navigationController.pushViewController(vc, animated: true)
        }
        
        AnaliticsService.shared.logEvent(name: Events.open_helper)
    }
    
    func goToCardCoin(tab: Tabs, coins: [ResultsCoins], images: [UIImage]?, category: Int) {
        setNavigation(for: tab)
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createSliderCoinsModule(router: self) as? SliderCardCoinViewController else { return }
            vc.presenter?.coins = coins
            vc.presenter?.images = images
            vc.presenter?.category = category
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func goToRecognition(images: [UIImage], category: Int) {
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createRecognitionModule(router: self) as? RecognitionViewController else { return }
            vc.presenter?.images = images
            vc.presenter?.category = category
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func goToMatch(images: [UIImage], coin: [ResultsCoins], category: Int) {
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createMatchModule(router: self) as? MatchViewController else { return }
            vc.isModalInPresentation = true
            vc.presenter?.images = images
            vc.presenter?.coin = coin
            vc.presenter?.category = category
            navigationController.viewControllers.last?.present(vc, animated: true)
        }
    }
    
    func goToAddCoin(view: UIViewController, id: Int, images: [UIImage], referecne: Int) {
        guard let vc = assemblyBuilder?.createAddCoinModule(router: self) as? AddCoinViewController else { return }
        vc.presenter?.images = images
        vc.presenter?.id = id
        vc.presenter?.reference = referecne
        vc.isModalInPresentation = true
        view.present(vc, animated: true)
    }
    
    func goToArticles(article: ArticleForCoins) {
        navigationController = controllers.first ?? navigationController
        if let navigationController = navigationController {
            guard let vc = assemblyBuilder?.createArticlesModule(router: self) as? ArticlesViewController else { return }
            vc.presenter?.article = article
            navigationController.pushViewController(vc, animated: true)
        }
        
        AnaliticsService.shared.logEvent(name: Events.open_articles)
    }
    
    func openPhotoLibrary() {
        if let navigationController = navigationController {
            guard let viewController = navigationController.viewControllers.last as? CameraViewController else { return }
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = viewController
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - pop
    func popToView(isAnimate: Bool = true) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: isAnimate)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: false)
        }
    }
    
    func dismiss(view: UIViewController, filter: Filter?, isAnimate: Bool = true, name: String = "") {
        guard let navigationController = navigationController,
              let currentVC = navigationController.viewControllers.last
            else { return }
        switch currentVC {
        case let vc as AllCoinsViewController:
            vc.presenter?.filter = filter
            vc.presenter?.filteredCoins()
        case is CollectionViewController:
            if (view as? SetNameViewController) != nil {
                (currentVC as? CollectionViewController)?.presenter.createCollection(name: name)
            }
            if (view as? PremiumViewController) != nil {
             //   (currentVC as? CollectionViewController)?.presenter.loadCollection()
            }
        case is FolderViewController:
            (currentVC as? FolderViewController)?.presenter?.rename(name: name)
        case is CameraViewController:
            if let view = view as? LoadViewController {
                navigationController.viewControllers.last?.dismiss(animated: false)
                self.popToRoot()
                self.goToFolder(tab: .camera,
                                collection: view.presenter?.item,
                                isShowAlert: true,
                                isAnimate: true)
            }
            
            if ((view as? SetNameViewController) != nil) {
                view.dismiss(animated: isAnimate)
                (currentVC.presentedViewController?.presentedViewController as? SelectCollectionViewController)?.presenter?.createCollection(name: name)
            }
        case is SliderCardCoinViewController:
            if let view = view as? LoadViewController {
                navigationController.viewControllers.last?.dismiss(animated: false)
                self.popToRoot()
                self.goToFolder(tab: .camera,
                                collection: view.presenter?.item,
                                isShowAlert: true,
                                isAnimate: true)
            }
            
            if ((view as? SetNameViewController) != nil) {
                view.dismiss(animated: isAnimate)
                (currentVC.presentedViewController as? SelectCollectionViewController)?.presenter?.createCollection(name: name)
            }
        default:
            break
        }
        
        view.dismiss(animated: isAnimate)
    }
}

extension RouterImpl: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

