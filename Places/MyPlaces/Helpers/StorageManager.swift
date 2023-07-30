//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Alexey Efimov on 07/12/2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place) {
        
        try! realm.write {
            realm.delete(place)
        }
    }
}
