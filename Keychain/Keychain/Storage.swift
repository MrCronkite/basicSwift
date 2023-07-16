//
//  Storage.swift
//  Keychain
//
//  Created by admin1 on 16.07.23.
//

import Security
import Foundation

protocol Keychain {
    func save() throws
    func load() throws -> Data?
    func delete() throws
}
