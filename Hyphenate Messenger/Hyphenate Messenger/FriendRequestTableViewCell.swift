//
//  FriendRequestTableViewCell.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 10/3/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
   
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func reuseIdentifier() -> String {
        return "FriendRequestCell"
    }
    
    @IBAction func declineAction(sender: AnyObject) {
        
    }
    @IBAction func acceptAction(sender: AnyObject) {
        
    }
}
