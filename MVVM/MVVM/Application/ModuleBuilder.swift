//
//  ModuleBuilder.swift
//  MVVM
//
//  Created by admin1 on 2.05.23.
//

import UIKit

class ModuleBuilder {
    static func createMain() -> UIViewController {
        let person = Person(name: "Vlad", age: 23)
        let viewModel = PersonViewModel(person: person)
        let viewController = ViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
