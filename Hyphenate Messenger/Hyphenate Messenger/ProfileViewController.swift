//
//  ProfileTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 10/2/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var username: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var audioCallButton: UIButton!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        usernameLabel.text = username
        self.tableView.registerNib(UINib(nibName: "ProfileNameTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileNameTableViewCell.reuseIdentifier())
        self.tableView.registerNib(UINib(nibName: "ProfileSwitchTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileSwitchTableViewCell.reuseIdentifier())
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 228.0/255.0, green: 233.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func back(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.section {
    
        case 0:
                let nameCell: ProfileNameTableViewCell = tableView.dequeueReusableCellWithIdentifier("profileNameCell", forIndexPath: indexPath) as! ProfileNameTableViewCell
                switch indexPath.row {
                
                case 0:
                    nameCell.title.text = "Hyphenate ID"
                    nameCell.userName.text = self.username
                case 1:
                    nameCell.title.text = "iOS APNS"
                    nameCell.userName.text = self.username
                default:
                    break
                }
            
            return nameCell
            
        case 1:
            let switchCell: ProfileSwitchTableViewCell = tableView.dequeueReusableCellWithIdentifier("profileSwitchCell", forIndexPath: indexPath) as! ProfileSwitchTableViewCell

            switch indexPath.row {
            case 0:
                switchCell.title.text = "Block Contact"
                switchCell.switchControl.setOn(false, animated: true)
            case 1:
                switchCell.title.text = "Delete Contact"
                switchCell.title.textColor = UIColor.redColor()
                switchCell.switchControl.hidden = true
            default:
                break
            }
            
            return switchCell
            
        default:
            break
        }

        return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        
        case 1:
            return 50
        
        default:
            break
        }
        return 0;
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
