

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var isAppLaunch = true
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    func sceneDidBecomeActive(_ scene: UIScene) {
        if !isAppLaunch {
            let isPremium = UserDefaults.standard.bool(forKey: R.Strings.KeyUserDefaults.premiumKey)
            if !isPremium {
               let _ = GoogleAd.shared.showAppOpen()
            }
            isAppLaunch = true
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
       isAppLaunch = false
    }
}

