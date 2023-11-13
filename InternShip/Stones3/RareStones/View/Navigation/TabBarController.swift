

import UIKit

enum Tabs: Int, CaseIterable {
    case home
    case detection
    case collection
    case aihelper
}

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
    }
}

extension TabBarController {
    private func configureAppearance() {
        tabBar.tintColor = R.Colors.active
        tabBar.unselectedItemTintColor = UIColor(hexString: "#CBD2E4")
        tabBar.backgroundColor = .white
        tabBar.barTintColor = UIColor(hexString: "#F9FBFF")
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(hexString: "#D8E2FE").cgColor
        
        let controllers: [UINavigationController] = Tabs.allCases.map { tab in
            let controller = UINavigationController(rootViewController: getController(for: tab))
            controller.tabBarItem = UITabBarItem(title: R.Strings.TabBar.title(for: tab),
                                                 image: R.ImagesBar.TabBar.icon(for: tab),
                                                 tag: tab.rawValue)
            return controller
        }
        setViewControllers(controllers, animated: false)
    }
    
    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .home : return HomeViewController()
        case .detection : return DetectionViewController()
        case .collection : return CollectionViewController()
        case .aihelper : return ChatViewController()
        }
    }
    
}
