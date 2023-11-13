

import UIKit

protocol UserSettings {
    func setPremium(_ isPremium: Bool, forKey key: UserSettingsImpl.Keys)
    func setToken(_ token: String, forKey key: UserSettingsImpl.Keys)
    func setStringArray(_ array: [String], forKey key: UserSettingsImpl.Keys)
    
    func premium(forKey key: UserSettingsImpl.Keys) -> Bool?
    func token(forKey key: UserSettingsImpl.Keys) -> String?
    func getArray(forKey key: UserSettingsImpl.Keys) -> [String]?
}

final class UserSettingsImpl {
    public enum Keys: String {
        case keyPremium
        case keyToken
        case keyArray 
    }
    
    private let userDefaults = UserDefaults.standard
    
    private func store(_ object: Any?, key: String) {
        userDefaults.set(object, forKey: key)
    }
    
    private func restore(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}

extension UserSettingsImpl: UserSettings {
    func setStringArray(_ array: [String], forKey key: Keys) {
        store(array, key: key.rawValue)
    }
    
    func getArray(forKey key: Keys) -> [String]? {
        return restore(forKey: key.rawValue) as? [String]
    }
    
    func setPremium(_ isPremium: Bool, forKey key: Keys) {
        store(isPremium, key: key.rawValue)
    }
    
     func setToken(_ token: String, forKey key: Keys) {
        store(token, key: key.rawValue)
    }
    
    func premium(forKey key: Keys) -> Bool? {
        restore(forKey: key.rawValue) as? Bool
    }
    
    func token(forKey key: Keys) -> String? {
        restore(forKey: key.rawValue) as? String
    }
}
