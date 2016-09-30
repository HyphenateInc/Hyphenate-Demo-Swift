//
//  BaseTableViewCell.swift
//  Hyphenate Messenger
//
//  Created by Kelvin Lam on 9/30/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import Foundation
import UIKit



class BaseTableViewCell:UITableViewCell{

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func reuseIdentifier() -> String {
        return "ContactCell"
    }
}