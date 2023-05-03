//
//  FruitListViewPresenterProtocol.swift
//  VIPER
//
//  Created by admin1 on 3.05.23.
//

import Foundation

protocol FruitListViewPresenterProtocol {
    func viewDidLoad()
}

final class FruitListPresenter: FruitListViewPresenterProtocol {
    
    weak var view: FruitListViewProtocol?
        var interactor: FruitListInteractorInputProtocol?
        var router: FruitListRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchFruits()
    }
}

// MARK: - FruitListInteractorOutputProtocol
extension FruitListPresenter: FruitListInteractorOutputProtocol {
    func didFetchFruits(fruits: [Fruit]) {
        view?.showFruits(with: fruits)
    }
}
