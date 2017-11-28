//
//  EMPublicGroupInfoViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/28.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class EMPublicGroupInfoViewController: UITableViewController {

    
    @IBOutlet weak var groupAvatar: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var owerLabel: UILabel!
    @IBOutlet weak var describeLabel: UILabel!
    
    @IBOutlet weak var bottomBtn: UIButton!
    
    var group: EMGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        
        reloadGroupInfo()
        bottomBtn.isHidden = true
        
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: group?.groupId) { (group, error) in
        MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow, animated: true)
            if error == nil {
                weakSelf?.bottomBtn.isHidden = false
                weakSelf?.group = group
                weakSelf?.reloadGroupInfo()
            }
        }
    }
    
    func reloadGroupInfo() {
        groupNameLabel.text = group?.subject
        owerLabel.text = group?.owner
        describeLabel.text = group?.description
        tableView.reloadData()
    }

    @IBAction func bottomBtnAction(_ sender: UIButton) {
        weak var weakSelf = self
        if group?.setting.style == EMGroupStylePublicJoinNeedApproval {
            let applyJoinAction = EMAlertAction.defaultAction(title: "Send", handler: { (alertAction) in
                let action = alertAction as! EMAlertAction
                let textField = action.alertController?.textFields?.first
                weakSelf?.showHub(inView: weakSelf?.view, "Send group of application......")
                EMClient.shared().groupManager.request(toJoinPublicGroup: weakSelf?.group?.groupId, message: textField?.text, completion: { (group, error) in
                    weakSelf?.hideHub()
                    if error == nil {
                        weakSelf?.show("Send succeed")
                        NotificationCenter.default.post(name: NSNotification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
                    }else {
                        weakSelf?.show((error?.errorDescription)!)
                    }
                })
            })
            let alertController = UIAlertController.textField(withTitle:"Say something", item: applyJoinAction)
            present(alertController, animated: true, completion: nil)
            
        } else if (group?.setting.style == EMGroupStylePublicOpenJoin) {
            weakSelf?.showHub(inView: weakSelf?.view, "Joining...")
            EMClient.shared().groupManager.joinPublicGroup(weakSelf?.group?.groupId, completion: { (group, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.show("Succeed")
                    NotificationCenter.default.post(name: NSNotification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
