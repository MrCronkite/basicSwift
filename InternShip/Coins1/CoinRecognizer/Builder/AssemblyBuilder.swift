

import UIKit
import AVFoundation
import Moya

protocol AssemblyBuilder {
    func createStartModule(router: RouterProtocol) -> UIViewController
    func createHomeModule(router: RouterProtocol) -> UIViewController
    func createCameraModule(router: RouterProtocol) -> UIViewController
    func createCollectionModule(router: RouterProtocol) -> UIViewController
    func createCatalogModule(router: RouterProtocol) -> UIViewController
    func createAllCoinsModule(router: RouterProtocol) -> UIViewController
    func createFilterModule(router: RouterProtocol) -> UIViewController
    func createSetNameModule(router: RouterProtocol) -> UIViewController
    func createSettingsModule(router: RouterProtocol) -> UIViewController
    func createFolderModule(router: RouterProtocol) -> UIViewController
    func createChatModule(router: RouterProtocol) -> UIViewController
    func createCardCoinModule(router: RouterProtocol) -> UIViewController
    func createRecognitionModule(router: RouterProtocol) -> UIViewController
    func createMatchModule(router: RouterProtocol) -> UIViewController
    func createAddCoinModule(router: RouterProtocol) -> UIViewController
    func createArticlesModule(router: RouterProtocol) -> UIViewController
    func createPayWallModule(router: RouterProtocol) -> UIViewController
    func createPremiumModule(router: RouterProtocol) -> UIViewController
    func createRetakeModule(router: RouterProtocol) -> UIViewController
    func createSelectModule(router: RouterProtocol) -> UIViewController
    func createLoadModule(router: RouterProtocol) -> UIViewController
    func createNoMatchModule(router: RouterProtocol) -> UIViewController
    func createSliderCoinsModule(router: RouterProtocol) -> UIViewController
    func createGalleryModule(router: RouterProtocol) -> UIViewController
}

final class AssemblyBuilderImpl: AssemblyBuilder {
    let googleAd = GoogleAdMobServiceImpl()
    
    func createStartModule(router: RouterProtocol) -> UIViewController {
        let vc = StartViewController()
        let storage = UserSettingsImpl()
        let registred = RegistredImpl()
        let presenter = StartPresenterImpl(view: vc,
                                           router: router,
                                           googleAd: googleAd,
                                           registred: registred,
                                           storage: storage)
        vc.presenter = presenter
        return vc 
    }
    
    func createCardCoinModule(router: RouterProtocol) -> UIViewController {
        let vc = CardCoinViewController()
        let provider = MoyaProvider<CoinsService>()
        let presenter = CardCoinPresenterImpl(view: vc,
                                              router: router,
                                              providerCoins: provider)
        vc.presenter = presenter
        return vc
    }
    
    func createHomeModule(router: RouterProtocol) -> UIViewController {
        let vc = HomeViewController()
        let storage = UserSettingsImpl()
        let provider = MoyaProvider<ArticleService>()
        let presenter = HomePresenterImpl(view: vc,
                                          router: router,
                                          googleAd: googleAd,
                                          storage: storage,
                                          provider: provider)
        vc.presenter = presenter
        return vc
    }
    
    func createCameraModule(router: RouterProtocol) -> UIViewController {
        let vc = CameraViewController()
        let session = AVCaptureSession()
        let storage = UserSettingsImpl()
        let presenter = CameraPresenterImpl(view: vc,
                                            router: router,
                                            session: session,
                                            googleAd: googleAd,
                                            storage: storage)
        vc.presenter = presenter
        return vc
    }
    
    func createCollectionModule(router: RouterProtocol) -> UIViewController {
        let vc = CollectionViewController()
        let provider = MoyaProvider<ClassificationAPIService>()
        let providerCoins = MoyaProvider<CoinsService>()
        let providerCollection = MoyaProvider<CollectionServices>()
        let storage = UserSettingsImpl()
        let presenter = CollectionPresenterImpl(view: vc,
                                                router: router,
                                                providerClassification: provider,
                                                providerCoins: providerCoins,
                                               providerCollection: providerCollection,
                                                storage: storage)
        vc.presenter = presenter
        return vc
    }
    
    func createCatalogModule(router: RouterProtocol) -> UIViewController {
        let vc = CatalogViewController()
        let storage = UserSettingsImpl()
        let provider = MoyaProvider<CoinsService>()
        let presenter = CatalogPresenterImpl(view: vc,
                                             router: router,
                                             googleAd: googleAd,
                                             storage: storage,
                                             provider: provider)
        vc.presenter = presenter
        return vc
    }
    
    func createPayWallModule(router: RouterProtocol) -> UIViewController {
        let vc = PayWallViewController()
        let presenter = PayWallPresenterImpl(view: vc,
                                             router: router,
                                             googleAdMob: googleAd)
        vc.presenter = presenter
        return vc
    }
    
    func createSliderCoinsModule(router: RouterProtocol) -> UIViewController {
        let vc = SliderCardCoinViewController()
        let presenter = SliderPresenterImpl(view: vc,
                                            router: router,
                                            assembly: self)
        vc.presenter = presenter
        return vc
    }
    
    func createPremiumModule(router: RouterProtocol) -> UIViewController {
        let vc = PremiumViewController()
        let presenter = PremiumPresenterImpl(view: vc,
                                             router: router,
                                             googleAdMob: googleAd)
        vc.presenter = presenter
        return vc
    }
    
    func createSelectModule(router: RouterProtocol) -> UIViewController {
        let vc = SelectCollectionViewController()
        let provider = MoyaProvider<CollectionServices>()
        let storage = UserSettingsImpl()
        let presenter = SelectPresenterImpl(view: vc,
                                            router: router,
                                            providerCollection: provider,
                                            storage: storage)
        vc.presenter = presenter
        return vc 
    }
    
    func createAllCoinsModule(router: RouterProtocol) -> UIViewController {
        let vc = AllCoinsViewController()
        let storage = UserSettingsImpl()
        let provider = MoyaProvider<CoinsService>()
        let presenter = AllCoinsPresenterImpl(view: vc,
                                              router: router,
                                              googleAd: googleAd,
                                              storage: storage,
                                              provider: provider)
        vc.presenter = presenter
        return vc
    }
    
    func createLoadModule(router: RouterProtocol) -> UIViewController {
        let vc = LoadViewController()
        let provider = MoyaProvider<CollectionServices>()
        let presenter = LoadPresenterImpl(view: vc, router: router, provider: provider)
        vc.presenter = presenter
        return vc
    }
    
    func createRetakeModule(router: RouterProtocol) -> UIViewController {
        let vc = RetakeViewController()
        let storage = UserSettingsImpl()
        let presenter = RetakePresenterImpl(view: vc, router: router, storage: storage)
        vc.presenter = presenter
        return vc
    }
    
    func createNoMatchModule(router: RouterProtocol) -> UIViewController {
        let vc = NoMatchViewController()
        let presenter = NoMatchPresenterImpl(view: vc,
                                             router: router)
        vc.presenter = presenter
        return vc
    }
    
    func createGalleryModule(router: RouterProtocol) -> UIViewController {
        let vc = GalleryViewController()
        let presenter = GalleryPresenterImpl(view: vc,
                                             router: router)
        vc.presenter = presenter
        return vc
    }
    
    func createFilterModule(router: RouterProtocol) -> UIViewController {
        let vc = FilterViewController()
        let presenter = FilterPresenterImpl(view: vc,
                                            router: router)
        vc.presenter = presenter
        return vc
    }
    
    func createSetNameModule(router: RouterProtocol) -> UIViewController {
        let vc = SetNameViewController()
        let presenter = SetNamePresenterImpl(view: vc,
                                             router: router)
        vc.presenter = presenter
        return vc
    }
    
    func createSettingsModule(router: RouterProtocol) -> UIViewController {
        let vc = SettingsViewController()
        let presenter = SettingsPresenterImpl(view: vc,
                                              router: router,
                                              googleAd: googleAd)
        vc.presenter = presenter
        return vc
    }
    
    func createFolderModule(router: RouterProtocol) -> UIViewController {
        let vc = FolderViewController()
        let storage = UserSettingsImpl()
        let provider = MoyaProvider<CollectionServices>()
        let providerCoins = MoyaProvider<CoinsService>()
        let presenter = FolderPresenterImpl(view: vc,
                                            router: router,
                                            googleAd: googleAd,
                                            storage: storage,
                                            providercollection: provider,
                                            providerCoins: providerCoins)
        vc.presenter = presenter
        return vc
    }
    
    func createChatModule(router: RouterProtocol) -> UIViewController {
        let vc = ChatViewController()
        let storage = UserSettingsImpl()
        let chatProvider = MoyaProvider<ChatAPI>()
        let presenter = ChatPresenterImpl(view: vc,
                                          router: router,
                                          storage: storage, chatProvider: chatProvider)
        vc.presenter = presenter
        return vc
    }
    
    func createRecognitionModule(router: RouterProtocol) -> UIViewController {
        let vc = RecognitionViewController()
        let provider = MoyaProvider<ClassificationAPIService>()
        let storage = UserSettingsImpl()
        let presenter = RecognitionPresenterImpl(view: vc,
                                                 router: router,
                                                 classificationProvider: provider,
                                                 storage: storage)
        vc.presenter = presenter
        return vc
    }
    
    func createMatchModule(router: RouterProtocol) -> UIViewController {
        let vc = MatchViewController()
        let provider = MoyaProvider<ClassificationAPIService>()
        let presenter = MatchViewPresenterImpl(view: vc,
                                               router: router,
                                               googleAd: googleAd,
                                               provider: provider)
        vc.presenter = presenter
        return vc
    }
    
    func createAddCoinModule(router: RouterProtocol) -> UIViewController {
        let vc = AddCoinViewController()
        let presenter = AddCoinPresenterImpl(view: vc,
                                             router: router,
                                             googleAd: googleAd)
        vc.presenter = presenter
        return vc
    }
    
    func createArticlesModule(router: RouterProtocol) -> UIViewController {
        let vc = ArticlesViewController()
        let settings = UserSettingsImpl()
        let presenter = ArticlesPresenterImpl(view: vc,
                                              router: router,
                                              googleAd: googleAd,
                                              settings: settings)
        vc.presenter = presenter
        return vc
    }
}


