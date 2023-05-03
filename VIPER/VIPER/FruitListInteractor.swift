//
//  FruitListInteractor.swift
//  VIPER
//
//  Created by admin1 on 3.05.23.
//

import Foundation

protocol FruitListInteractorInputProtocol {
    func fetchFruits()
}

protocol FruitListInteractorOutputProtocol {
    func didFetchFruits(fruits: [Fruit])
}

class FruitListInteractor: FruitListInteractorInputProtocol {
    
    var output: FruitListInteractorOutputProtocol?
    var fruitService: FruitServiceProtocol?

    func fetchFruits() {
        fruitService?.fetchFruits { [weak self] (fruits) in
            self?.output?.didFetchFruits(fruits: fruits)
        }
    }
}
