

import UIKit

enum R {
    enum Colors {
        static let inactive = UIColor(hexString: "#CBD2E4")
        static let active = UIColor(hexString: "#708FE8")
        static let purple = UIColor(hexString: "#DAD1FB")
        static let textColor = UIColor(hexString: "#746685")
        static let blueLight = UIColor(hexString: "#b1d3ff")
        static let darkGrey = UIColor(hexString: "#4C4752")
        static let whiteBlue = UIColor(hexString: "#dce5fd")
        static let roseBtn = UIColor(hexString: "#BD82FF")
    }
    
    enum Strings {
        enum TabBar {
            static func title(for tab: Tabs) -> String {
                switch tab {
                case .home : return "tab_home".localized
                case .detection : return "tab_detection".localized
                case .collection : return "tab_history".localized
                case .aihelper : return "tab_Ai_helper".localized
                }
            }
        }
        
        enum Onbording {
            static let images = ["ston1", "ston2", "ston3", "ston4"]
        }
        
        enum Camera {
            static let loadingText = ["cam_pt_looking_1".localized, "cam_pt_looking_2".localized, "cam_pt_looking_3".localized]
            static let styles: [UIBlurEffect.Style] = [.dark, .extraLight, .prominent, .systemChromeMaterial, .systemThinMaterialLight, .systemMaterial, .systemUltraThinMaterialDark, .regular, .systemChromeMaterial, .systemUltraThinMaterialLight]
        }
        
        enum AiHelper {
            static let message = "helper_mess".localized
            static var questions = ["helper_question4",
                                    "helper_question2",
                                    "helper_question3",
                                    "helper_question1"]
        }
        
        enum KeyAd {
            static let bannerAdKey = "ca-app-pub-3940256099942544/2934735716"
            static let rewardedInterKey = "ca-app-pub-3940256099942544/6978759866"
            static let appOpenAdKey = "ca-app-pub-3940256099942544/5662855259"
            static let interKey = "ca-app-pub-3940256099942544/4411468910"
        }
        
        enum AppStoreAppId {
            static let key = "6468950748"
        }
        
        enum Analytics {
            static let AppMetrica = "0d368292-e31a-43a7-ac99-04dd0c6a1d39"
            static let AppsFlyer = "pEzH3ozk2uWq8jX8VZKN4C"
        }
        
        enum KeyUserDefaults {
            static let tokenKey = "TokenKey"
            static let premiumKey = "premiumKey"
            static let questions = "questions"
        }
        
        enum KeyProduct {
            static let sharedKey = "e6dd59b76a9144528f8e1fed879dc0ab"
            static let idSub = "gemidentifier.com.1week"
            static let idPremium = "gemidentifier.com.1week.intro"
            static let userAcquisitionApiKey = "2vG_-Qhr-fVrPGrvzcO6"
        }
         
        enum Links {
            static let privacy = "https://gem-identifier.com/privacy.html"
            static let terms = "https://gem-identifier.com/terms.html"
            static let supportEmail = "info@gem-identifier.com"
            static let rateLinksApp = "itms-apps://itunes.apple.com/app/id6462852035?action=write-review"
        }
    }
    
    enum ImagesBar {
        enum TabBar {
            static func icon(for tab: Tabs) -> UIImage? {
                switch tab {
                case .home : return UIImage(named: "home")
                case .detection : return UIImage(named: "detection")
                case .collection : return UIImage(named: "collection")
                case .aihelper : return UIImage(named: "chat")
                }
            }
        }
    }
    
    enum Font {
        static func helvetica(with size: CGFloat) -> UIFont {
            UIFont(name: "Helvetica", size: size) ?? UIFont()
        }
    }
}
