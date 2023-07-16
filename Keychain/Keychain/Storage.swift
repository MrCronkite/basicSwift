//
//  Storage.swift
//  Keychain
//
//  Created by admin1 on 16.07.23.
//

import Security
import Foundation

protocol Keychain {
    func save(key: KeychainImpl.Keys, data: String) throws
    func load(key: KeychainImpl.Keys) throws -> Data?
    func delete(key: KeychainImpl.Keys) throws
}

final class KeychainImpl: Keychain {
    public enum Keys: String {
        case jeyData
    }
    
    private enum KeychainError: Error {
        case saveFailed
        case loadFailed
        case deleteFailed
    }
    
    func save(key: Keys, data: String) throws {
        let dataString = data.data(using: .utf8)!
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: dataString
        ] as [String: Any]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.saveFailed
        }
    }
    
    func load(key: Keys) throws -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess {
            return result as? Data
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.loadFailed
        }
    }
    
    func delete(key: Keys) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.deleteFailed
        }
    }
}
