//
//  SwitchTableViewCell.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 10/1/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var uiswitch: UISwitch!
    @IBOutlet weak var title: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
