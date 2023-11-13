

import UIKit

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
    }
    
    override func viewWillLayoutSubviews() {
        let bgView = UIImageView(image: Asset.Assets.tabbg.image)
        bgView.frame = tabBar.bounds
        tabBar.addSubview(bgView)
        tabBar.sendSubviewToBack(bgView)
    }
    
    @objc private func showCamera() {
        tabBarController?.selectedIndex = 1
    }
}

extension TabBarController {
    private func configureAppearance() {
        self.delegate = self
        self.tabBar.tintColor = Asset.Color.white.color
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        self.tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = appearance
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            tabBarController.selectedViewController?.tabBarItem.image = Asset.Assets.home.image
            tabBarController.viewControllers?[2].tabBarItem.image = Asset.Assets.inCollect.image
        case 2:
            tabBarController.selectedViewController?.tabBarItem.image = Asset.Assets.collection.image
            tabBarController.viewControllers?[0].tabBarItem.image = Asset.Assets.inHome.image
        default:
            break
        }
    }
}
