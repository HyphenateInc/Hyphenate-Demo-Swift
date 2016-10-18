//
//  SettingsNotificationTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 10/18/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class SettingsNotificationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        self.tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        title = "Push Notifications"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            let cell: SwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
            cell.title.text = "Display on lockscreen"
            cell.uiswitch.setOn(true, animated: true)
            return cell
            
        case 1:
            let cell: SwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
            cell.title.text = "Push Notifications"
            cell.uiswitch.setOn(true, animated: true)
            return cell
            
        case 2:
            let cell: LabelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
            cell.titleLabel.text = "Notification display name"
            if let hyphenateID = EMClient.shared().currentUsername {
                cell.detailLabel.text = "\(hyphenateID)"
            }
            cell.accessoryType = .disclosureIndicator
            return cell
            
        default: break
            
        }
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
}
