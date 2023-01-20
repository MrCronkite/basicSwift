//
//  ViewController.swift
//  Delegate
//
//  Created by admin1 on 19.01.23.
//

import UIKit

class ViewController: UIViewController, SecondScrenDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func getString(text: String?) {
        print(text ?? "nil")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func tapButton(sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "secondVC" ) as! SecondVC
        vc.modalPresentationStyle  = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.preferredContentSize = CGSizeMake(300, 300)
        vc.delegate = self
        
        show(vc, sender: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SomeCell
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello \(indexPath.row)")
    }
}
