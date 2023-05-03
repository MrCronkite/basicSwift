//
//  FruitListViewController.swift
//  VIPER
//
//  Created by admin1 on 3.05.23.
//

import UIKit

class FruitListViewController: UIViewController {
    
    var presenter: FruitListViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }


}

// MARK: - FruitListViewProtocol
extension FruitListViewController: FruitListViewProtocol {
    func showFruits(with fruits: [Fruit]) {
        // display the fruits in a UITableView or any other kind of view
    }
}

