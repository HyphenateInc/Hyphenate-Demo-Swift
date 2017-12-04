//
//  EMGroupSettingsViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/4.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class EMGroupSettingsViewController: UITableViewController {

    @IBOutlet weak var blockMessageSwitch: UISwitch!
    @IBOutlet weak var notificationsSwitch: UISwitch!

    var group: EMGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group Settings"
        tableView.tableFooterView = UIView()
        setupBackAction()
        fetchSettingsInfo()
    }
    
    func fetchSettingsInfo() {
        weak var weakSelf = self
        if group != nil {
            MBProgressHUD.showInMainWindow()
            EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: group?.groupId, completion: { (group, error) in
                MBProgressHUD.hideHubInMainWindow()
                if error == nil {
                    weakSelf?.group = group
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
                weakSelf?.setupInfo()
            })
        }
    }
    
    func setupInfo() {
        blockMessageSwitch.isOn = group?.isBlocked ?? false
        notificationsSwitch.isOn = group?.isPushNotificationEnabled ?? false
    }
    
    @IBAction func blockMessagesSwitchChange(_ sender: UISwitch) {
        weak var weakSelf = self
        weakSelf?.showHub(inView: weakSelf?.view, "Uploading...")
        EMClient.shared().groupManager.blockGroup(group?.groupId) { (result, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.group = result
            }else {
                sender.isOn = !sender.isOn
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    @IBAction func receiveWithoutNottifiersSwitchChange(_ sender: UISwitch) {
        weak var weakSelf = self
        weakSelf?.showHub(inView: weakSelf?.view, "Uploading...")
        EMClient.shared().groupManager.updatePushService(forGroups: [(group?.groupId)!], isPushEnabled: sender.isOn) { (groupIds, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.group = groupIds?.first as? EMGroup
            }else {
                sender.isOn = !sender.isOn
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
}
