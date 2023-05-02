//
//  PersonViewModel.swift
//  MVVM
//
//  Created by admin1 on 2.05.23.
//

import Foundation

final class PersonViewModel {
    private let person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    var name: String {
        return person.name
    }
    
    var ageText: String {
        return "Age: \(person.age)"
    }
}

