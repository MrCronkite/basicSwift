

import Foundation

enum Events {
    //Start
    static let view_start_loading = "view_start_loading"
    static let view_onbording_first = "view_onbording_first"
    static let view_onbording_second = "view_onbording_second"
    static let view_subscription = "view_subscription"
    static let open_offer_subscription = "open_offer_subscription"
    static let close_offer_subscription = "close_offer_subscription"
    static let done_subscription = "done_subscription"
    static let skip_view_subscription = "skip_view_subscription"
    static let open_restore_subscription = "open_restore_subscription"
    static let done_restore_subscription = "done_restore_subscription"
    
    //Home
    static let open_home_view = "open_home_view"
    static let open_articles = "open_articles"
    static let open_zodiac = "open_zodiac"
    static let open_all_stone = "open_all_stone"
    static let open_healing_stone = "open_healing_stone"
    static let open_rare_stone = "open_rare_stone"
    
    //Detector
    static let open_detection_view = "open_detection_view"
    static let start_detection_button = "start_detection_button"
    static let open_subscribe_or_ad_view = "open_subscribe_or_ad_view"
    static let close_subscribe_or_ad_view = "close_subscribe_or_ad_view"
    static let detect_stone = "detect_stone"
    static let detect_screen = "detect_screen"
    
    //History
    static let request_history_view = "open_history_view"
    static let open_history_view = "open_history_view"
    static let request_wish_list = "request_wish_list"
    static let open_wish_list = "open_wish_list"
    static let open_settings_view = "open_settings_view"
    
    //AiHelper
    static let open_aihelper_view = "open_aihelper_view"
    static let questions_aihelper = "questions_aihelper"
    static let free_message_off = "free_message_off"
    
    //Camera
    static let open_camera_view = "open_camera_view"
    static let camera_view_allow = "camera_view_allow"
    static let camera_view_disallow = "camera_view_disallow"
    static let open_photo_tips = "open_photo_tips"
    static let close_camera_view = "close_camera_view"
    static let open_photo_galery = "open_photo_galery"
    static let photo_taken_galery = "photo_taken_galery"
    static let photo_taken_on_camera = "photo_taken_on_camera"
    static let open_view_match_subscribe = "open_view_match_subscribe"
    static let close_view_match_subscribe = "close_view_match_subscribe"
    static let open_view_match = "open_view_mathc"
    static let close_view_mathc = "close_view_mathc"
    static let open_view_no_match = "open_view_no_match"
    
    //Other
    static let get_premium_view = "get_premium_view"
    static let premium_button = "premium_button"
    static let premium_close = "premium_close"
    static let premium_done  = "premium_done"
    static let get_premium_skip = "get_premium_skip"
    static let premium_restore = "premium_restore"
    static let premium_restore_done = "premium_restore_done"
    static let open_card_stone = "open_card_stone"
    
    //Ad
    static let rewarded_inter_request = "rewarded_inter_request"
    static let rewarded_inter_view = "rewarded_inter_view"
    static let rewarded_inter_error = "rewarded_inter_error"
    static let inter_request = "inter_request"
    static let inter_view = "inter_view"
    static let inter_error = "inter_error"
    static let appOpen_view = "appOpen_view"
    static let appOpen_error = "appOpen_error"
}
