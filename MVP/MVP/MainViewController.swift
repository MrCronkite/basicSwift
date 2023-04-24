//
//  MainViewController.swift
//  MVP
//
//  Created by admin1 on 24.04.23.
//

import UIKit

class MainViewController: UIViewController {
    
    var presenter: MainViewPresenterProtocol!
    
    private let textLable: UILabel = {
       let lable = UILabel()
        lable.text = "Heelo world"
        lable.font = UIFont.systemFont(ofSize: 20)
        return lable
    }()
    
    private let buttonPerson: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("GetName", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        configureMainViewController()
    }
    
    @objc func getFullName() {
        self.presenter.showGreeting()
    }
    
}



extension MainViewController: MainViewProtocol {
    func setGreeting(greeting: String) {
        self.textLable.text = greeting
    }
    
    private func configureMainViewController() {
        [textLable, buttonPerson].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            textLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonPerson.topAnchor.constraint(equalTo: textLable.bottomAnchor, constant: 30),
            buttonPerson.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)

        ])
        
        buttonPerson.addTarget(self, action: #selector(getFullName), for: .touchUpInside)
    }
}

