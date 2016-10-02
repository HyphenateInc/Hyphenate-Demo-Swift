//
//  ConversationTableViewCell.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 10/1/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderImageView.layer.cornerRadius = senderImageView.frame.size.width / 2
        senderImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
