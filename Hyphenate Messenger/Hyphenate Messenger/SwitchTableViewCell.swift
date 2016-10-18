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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if title.text == "Push Notifications" {
            if selected == true {
                let pushSettings = UIUserNotificationSettings(types:[UIUserNotificationType.badge ,UIUserNotificationType.sound ,UIUserNotificationType.alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(pushSettings)
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                UIApplication.shared.unregisterForRemoteNotifications()
            }
        }
    }
}
