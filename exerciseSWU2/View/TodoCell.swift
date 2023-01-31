//
//  TodoCell.swift
//  Exerciswu-main
//
//  Created by YoonJu on 2023/01/28.
//

import UIKit

class TodoCell:UITableViewCell {
    
    @IBOutlet weak var chkBox: UIButton!
    @IBAction func chkBoxTapped(_ sender: Any) {
        chkBox.tintColor = .black
        chkBox.isSelected.toggle()
    }
    @IBOutlet weak var todoLabel: UILabel!
    
}
