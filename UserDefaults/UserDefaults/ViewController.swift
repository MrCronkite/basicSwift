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
        statusLabel.text = "Запусков приложений \(UserDefaults.standard.integer(forKey: numberOfLaunch))"
        textField.text = UserDefaults.standard.string(forKey: inputText)
        segmentControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: segmentIndex)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        guard let text = textField.text else {return}
        UserDefaults.standard.set(text, forKey: inputText)
        
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
    }
    
    @IBAction func segmentState(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: segmentIndex)
    }
    
    func saveCurentLaunch() {
        let save = UserDefaults.standard.integer(forKey: numberOfLaunch)
        UserDefaults.standard.set(save + 1, forKey: numberOfLaunch)
    }
    
    
    //MARK: - Private Key
    private let numberOfLaunch = "NumberOfLaunches"
    private let inputText = "TextKeyInput"
    private let segmentIndex = "SegmentKey"

}

