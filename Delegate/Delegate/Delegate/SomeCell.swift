//
//  SomeCell.swift
//  Delegate
//
//  Created by admin1 on 20.01.23.
//

import UIKit


protocol DelegateCell: AnyObject {
    func didCell(_ cell: SomeCell)
}


class SomeCell: UITableViewCell {
    
    weak var delegate: DelegateCell?
    
    @IBAction func didTapButton() {
        delegate?.didCell(self)
        
    }
    
    
}
