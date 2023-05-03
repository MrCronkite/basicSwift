//
//  FruitListRouter.swift
//  VIPER
//
//  Created by admin1 on 3.05.23.
//

import UIKit

protocol FruitListRouterProtocol {
    static func createFruitListModule() -> UIViewController
}

class FruitListRouter: FruitListRouterProtocol {

    static func createFruitListModule() -> UIViewController {
        let view = FruitListViewController()
        let presenter = FruitListPresenter()
        let interactor = FruitListInteractor()
        let router = FruitListRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        interactor.fruitService = FruitService()

        return view
    }
}
