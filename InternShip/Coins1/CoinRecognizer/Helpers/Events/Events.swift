

import Foundation

enum Events {
    //Start
    static let view_start_loading = "view_start_loading"
    static let view_onbording = "view_onbording"
    static let view_subscription = "open_view_subscription"
    static let open_offer_subscription = "open_offer_subscription"
    static let close_offer_subscription = "close_offer_subscription"
    static let done_subscription = "subscription_done"
    static let skip_view_subscription = "skip_view_subscription"
    static let open_restore_subscription = "open_restore_subscription"
    static let done_restore_subscription = "restore_done"
    
    //home
    static let open_home_view = "open_home_view"
    static let open_articles = "open_articles"
    static let open_premium = "open_premium"
    static let open_catalog = "open_catalog"
    static let open_helper = "open_helper"
    static let open_allcoins = "open_allcoins"
    static let opne_collection = "opne_collection"
    
    //camera
    static let open_camera_view = "open_camera_view"
    static let camera_view_allow = "camera_view_allow"
    static let camera_view_disallow = "camera_view_disallow"
    static let close_camera_view = "close_camera_view"
    static let open_photo_galery = "open_photo_galery"
    static let photo_taken_galery = "photo_taken_galery"
    static let photo_taken_on_camera = "photo_taken_on_camera"
    static let open_view_match = "open_view_mathc"
    static let close_view_mathc = "close_view_mathc"
    static let open_view_no_match = "open_view_no_match"
    static let open_card_coins_result = "open_card_coins_result"
    static let open_alert_rate = "open_alert_rate"
    static let close_alert_rate = "close_alert_rate"
    
    //ad
    static let rewarded_inter_request = "rewarded_inter_request"
    static let rewarded_inter_view = "rewarded_inter_view"
    static let inter_request = "inter_request"
    static let inter_view = "inter_view"
    static let appOpen_view = "appOpen_view"
    
    //collection
    static let add_to_collection = "add_to_collection"
    static let add_to_collection_catalog = "add_to_collection_catalog"
    static let add_to_collection_recognition = "add_to_collection_recognition"
    static let open_adwatch_or_sub = "open_adwatch_or_sub"
    static let close_adwatch_or_sub = "close_adwatch_or_sub"
    static let coin_succes_add_to_collection = "coin_succes_add_to_collection"
}

