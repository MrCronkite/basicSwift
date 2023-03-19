//
//  StoreManager.swift
//  UserDefaults
//
//  Created by admin1 on 19.03.23.
//

import Foundation


protocol StorageManagerProtocol {
    func set(_ object: Any?, forKey key: StorageManager.Keys)
    func set<T: Encodable>(object: T?, forKey key: StorageManager.Keys)
    
    func int(forKey key: StorageManager.Keys) -> Int?
    func string(forKey key: StorageManager.Keys) -> String?
    func dict(forKey key: StorageManager.Keys) -> [String: Any]?
    func date(forKey key: StorageManager.Keys) -> Date?
    func data(forKey key: StorageManager.Keys) -> Data?
    func bool(forKey key: StorageManager.Keys) -> Bool?
    func codableData<T: Decodable>(forKey key: StorageManager.Keys) -> T?
    
}

final class StorageManager {
    public enum Keys: String {
        case test
    }
    
    private let userDefaults = UserDefaults.standard
    
    private func store(_ object: Any?, key: String) {
        userDefaults.set(object, forKey: key)
    }
    
    private func restore(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
    
}

extension StorageManager: StorageManagerProtocol {
    func set(_ object: Any?, forKey key: Keys) {
        store(object, key: key.rawValue)
    }
    
    func set<T: Encodable>(object: T?, forKey key: Keys) {
        let jsonData = try? JSONEncoder().encode(object)
        store(jsonData, key: key.rawValue)
    }
    
    func int(forKey key: Keys) -> Int? {
        restore(forKey: key.rawValue) as? Int
    }
    
    func string(forKey key: Keys) -> String? {
        restore(forKey: key.rawValue) as? String
    }
    
    func dict(forKey key: Keys) -> [String : Any]? {
        restore(forKey: key.rawValue) as? [String: Any]
    }
    
    func date(forKey key: Keys) -> Date? {
        restore(forKey: key.rawValue) as? Date
    }
    
    func data(forKey key: Keys) -> Data? {
        restore(forKey: key.rawValue) as? Data
    }
    
    func bool(forKey key: Keys) -> Bool? {
        restore(forKey: key.rawValue) as? Bool
    }
    
    func codableData<T: Decodable>(forKey key: Keys) -> T? {
        guard let data = restore(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func remove(forKey key: Keys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

