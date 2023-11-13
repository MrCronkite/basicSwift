

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var isAppLaunch = true
    private var router: RouterProtocol?
    private let storage = UserSettingsImpl()
    private let assembly = AssemblyBuilderImpl()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        router = RouterImpl(navigationController: UINavigationController(),
                                assemblyBuilder: assembly,
                                window: window)
        router?.setupInitialViewController(initialView: .tabBar)
        
        assembly.googleAd.loadInterAd()
        assembly.googleAd.loadAppOpen()
        assembly.googleAd.loadRewardedInter()
    }
}

extension SceneDelegate {
    func sceneDidBecomeActive(_ scene: UIScene) {
        if !isAppLaunch {
            let isPremium = storage.premium(forKey: .keyPremium)!
            if !isPremium {
              let _ = assembly.googleAd.showAppOpen()
            }
            isAppLaunch = true
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
       isAppLaunch = false
    }
}

