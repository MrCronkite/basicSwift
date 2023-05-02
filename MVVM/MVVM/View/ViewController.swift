//
//  ViewController.swift
//  MVVM
//
//  Created by admin1 on 2.05.23.
//

import UIKit

final class ViewController: UIViewController {
    
    var viewModel: PersonViewModel!
    
    var nameLable: UILabel = {
       let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = .blue
        return text
    }()
    
    var ageLable: UILabel = {
       let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 12)
        text.textColor = .gray
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureView()
    }

}

extension ViewController {
    private func configureView() {
        [nameLable, ageLable].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nameLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ageLable.topAnchor.constraint(equalTo: nameLable.bottomAnchor, constant: 10),
            ageLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        nameLable.text = viewModel.name
        ageLable.text = viewModel.ageText
    }
}

