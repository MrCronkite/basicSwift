//
//  ViewController.swift
//  UserDefaults
//
//  Created by admin1 on 22.01.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveCurentLaunch()
        statusLabel.text = "Запусков приложений \(UserDefaults.standard.integer(forKey: "NumberOfLaunches"))"
    }
    
    
    func saveCurentLaunch() {
        let save = UserDefaults.standard.integer(forKey: "NumberOfLaunches")
        UserDefaults.standard.set(save + 1, forKey: "NumberOfLaunches")
    }

}

