//
//  SettingsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/27/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFrame = CGRectMake(0, 0, 32, 32)
        let title:UILabel = UILabel(frame: titleFrame)
        title.text = "Settings"
        navigationItem.titleView = title
        self.tableView.backgroundColor = UIColor(red: 228.0/255.0, green: 233.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerNib(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        switch indexPath.row {
        case 0:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "About"
            cell.accessoryType = .DisclosureIndicator
            return cell

        case 1:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Push Notifications"
            cell.accessoryType = .DisclosureIndicator
            return cell

        case 2:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Account"
            cell.accessoryType = .DisclosureIndicator
            return cell

        case 3:
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            cell.textLabel?.text = "Chats"
            cell.accessoryType = .DisclosureIndicator
            return cell

        case 4:
            let switchCell: SwitchTableViewCell = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as! SwitchTableViewCell
            switchCell.uiswitch.setOn(true, animated: true)
            switchCell.title.text = "Adaptive Video Bitrate"
            return switchCell

        default: break
            
        }
     return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    }
}
