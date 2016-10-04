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
        let titleFrame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let title:UILabel = UILabel(frame: titleFrame)
        title.text = "Settings"
        navigationItem.titleView = title
        self.tableView.backgroundColor = UIColor(red: 228.0/255.0, green: 233.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch (indexPath as NSIndexPath).row {
        case 0:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "About"
            cell.accessoryType = .disclosureIndicator
            return cell

        case 1:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Push Notifications"
            cell.accessoryType = .disclosureIndicator
            return cell

        case 2:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Account"
            cell.accessoryType = .disclosureIndicator
            return cell

        case 3:
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Chats"
            cell.accessoryType = .disclosureIndicator
            return cell

        case 4:
            let switchCell: SwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
            switchCell.uiswitch.setOn(true, animated: true)
            switchCell.title.text = "Adaptive Video Bitrate"
            return switchCell

        default: break
            
        }
     return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
}
