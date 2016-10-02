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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
