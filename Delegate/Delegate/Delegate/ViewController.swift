//
//  ViewController.swift
//  Delegate
//
//  Created by admin1 on 19.01.23.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func tapButton(sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "secondVC" ) as! SecondVC
        
        vc.modalPresentationStyle  = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.preferredContentSize = CGSizeMake(300, 300)
       
        show(vc, sender: nil)
    }
    


}

