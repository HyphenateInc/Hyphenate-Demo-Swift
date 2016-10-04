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
    var request: RequestEntity!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func reuseIdentifier() -> String {
        return "FriendRequestCell"
    }
    
    @IBAction func declineAction(sender: AnyObject) {
        EMClient.sharedClient().contactManager.declineFriendRequestFromUser(usernameLabel.text) { (userName, error) in
            if error != nil {
                let alert = UIAlertController(title:"Error", message: "Fail declining a friend request, please try again", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            } else {
                InvitationManager.sharedInstance.removeInvitation(self.request, loginUser: EMClient.sharedClient().currentUsername)
            }
        }
    }
    
    @IBAction func acceptAction(sender: AnyObject) {
        EMClient.sharedClient().contactManager.approveFriendRequestFromUser(usernameLabel.text) { (userName, error) in
            if error != nil {
                let alert = UIAlertController(title:"Error", message: "Fail accepting a friend request, please try again", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            } else {
                InvitationManager.sharedInstance.removeInvitation(self.request, loginUser: EMClient.sharedClient().currentUsername)
            }
        }
    }
}
