//
//  ModuleBuilder.swift
//  MVP
//
//  Created by admin1 on 24.04.23.
//

import UIKit

protocol Builder {
    static func createMain() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMain() -> UIViewController {
        let model = Person(firstName: "David", lastName: "Laid")
        let view = MainViewController()
        let presenter = MainPresenter(view: view, person: model)
        view.presenter = presenter
        return view
    }
}
