

import UIKit

enum R {
    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .home: return "ob_home".localized
                case .collection: return "ob_collection".localized
                case .camera: return ""
                }
            }
        }
        
        enum Onbording {
            static let strings: [String] = ["ob_title1".localized,
                                            "ob_title2".localized,
                                            "ob_title3".localized,
                                            "ob_title4".localized]
        }
        
        enum Analytics {
            static let AppMetrica = "e947a5f3-c6b6-40b6-811f-b8a17213ddf2"
            static let AppsFlyer = "pzGmDDD4C2dt5mrXHj3Q6E"
        }
        
        enum AppStoreAppId {
            static let key = "6462852035"
        }
        
        enum GoogleAdMobKeys {
            static let bannerAdKey = "ca-app-pub-3940256099942544/2934735716"
            static let rewardedInterKey = "ca-app-pub-3940256099942544/6978759866"
            static let appOpenAdKey = "ca-app-pub-3940256099942544/5662855259"
            static let interKey = "ca-app-pub-3940256099942544/4411468910"
            
            static let bannner = "ca-app-pub-3940256099942544/2934735716"
            static let interstitial = "ca-app-pub-3940256099942544/4411468910"
            static let appOpen = "ca-app-pub-3940256099942544/5662855259"
            static let rewardedInter = "ca-app-pub-3940256099942544/6978759866"
        }
        
        enum Prducts {
            static let sharedKey = "960f4e5fb9584064b3cd189d845234a7"
            static let premiumId = "aicoins.com.1w.intro"
            static let subscribeId = "aicoins.com.1w"
            static let userAcquisition = "yiU0UzCiAjK5LEhKhQbZ"
        }
        
        enum Camera {
            static let step1 = ["cam_step1".localized, "cam_step1_sub".localized]
            static let step2 = ["cam_step2".localized, "cam_step2_sub".localized]
        }
        
        enum Home {
            static let material = ["gold".localized, "silver".localized, "platinum".localized, "copper".localized, "aluminum".localized, "zinc".localized, "nickel".localized, "palladium".localized]
        }
        
        enum Collection {
            static let history = ["history_title".localized, "history_subtitle".localized]
            static let favorites = ["fav_title".localized, "fav_subtitle".localized]
        }
        
        enum Settings {
            static let support = ["contact_us".localized, "restore".localized]
            static let feedback = ["rate_app".localized, "share_the_app".localized]
            static let security = ["privacy".localized, "term_of_use".localized]
        }
        
        enum Links {
            static let email = "info@ai-coins.pro"
            static let rate = ""
            static let privacyPolicy = "https://ai-coins.pro/privacy.html"
            static let share = ""
            static let termOfUse = "https://ai-coins.pro/terms.html"
        }
        
        enum Chat {
            static let firstMessage = "start_message".localized
            static let tips = ["helper_1", "helper_2", "helper_3", "helper_4"]
        }
    }
    
    enum Images {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .home: return Asset.Assets.home.image
                case .collection: return Asset.Assets.inCollect.image
                case .camera: return UIImage()
                }
            }
        }
        
        enum Collection {
            static let colors: [UIColor] = [Asset.Color.midNativ.color,
                                            Asset.Color.midBlue.color,
                                            Asset.Color.midPurple.color,
                                            Asset.Color.midPink.color,
                                            Asset.Color.midYellow.color,
                                            Asset.Color.midGreen.color]
            
            static let colorBG: [UIColor] = [Asset.Color.mainBej.color,
                                             Asset.Color.mainBlue.color,
                                             Asset.Color.mainPurple.color,
                                             Asset.Color.mainPink.color,
                                             Asset.Color.mainYellow.color,
                                             Asset.Color.mainGreen.color]
            
            static let images: [UIImage] = [Asset.Assets.folder.image,
                                            Asset.Assets.folderBlue.image,
                                            Asset.Assets.folderViolet.image,
                                            Asset.Assets.folderPink.image,
                                            Asset.Assets.folderYellow.image,
                                            Asset.Assets.folderGreen.image]
        }
        
        enum Settings {
            static let support: [UIImage] = [Asset.Assets.edit.image,
                                             Asset.Assets.bag.image]
            static let feedback: [UIImage] = [Asset.Assets.star.image,
                                              Asset.Assets.person.image]
            static let security: [UIImage] = [Asset.Assets.funlock.image,
                                              Asset.Assets.circle.image]
        }
    }
}
