//
//  EMGroupInfoViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/30.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMGroupInfoViewController: UITableViewController {

    var group: EMGroup?
    var isOwner = false
    var isAdmin = false
    
    @IBOutlet weak var groupIdLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var announcementLabel: UILabel!
    @IBOutlet weak var adminsCountLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var extensionLabel: UILabel!
    @IBOutlet weak var blacksCountLabel: UILabel!
    @IBOutlet weak var mutesCount: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group Info"
        isOwner = group?.owner == EMClient.shared().currentUsername
        setupBackAction()
        setupSettingsItem()
        NotificationCenter.default.addObserver(self, selector: #selector(updateGroupInfo), name: NSNotification.Name(rawValue:KEM_REFRESH_GROUP_INFO), object: nil)
        updateGroupInfo()
        fetchGroupInfo()
    }
    
    func setupSettingsItem() {
        navigationItem.rightBarButtonItem = {
            let item = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(pushToSettingsVC))
            item.tintColor = KermitGreenTwoColor
            return item
        }()
    }
    
    func fetchGroupInfo() {
        weak var weakSelf = self
        weakSelf?.showHub(inView: view, "Fetching...")
        EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: group?.groupId) { (resultGroup, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.group = resultGroup
                weakSelf?.updateGroupInfo()
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    @objc func pushToSettingsVC() {
        let stroyboard = UIStoryboard.init(name: "GroupInfo", bundle: nil)
        let setttingsVC = stroyboard.instantiateViewController(withIdentifier: "EMGroupSettingsViewController") as! EMGroupSettingsViewController
        setttingsVC.group = group
        navigationController?.pushViewController(setttingsVC, animated: true)
    }
    
    @objc func updateGroupInfo() {
        isAdmin = (group!.adminList.contains(where: { (username) -> Bool in
            return (username as! String) == EMClient.shared().currentUsername
        }))
        isOwner = group!.owner == EMClient.shared().currentUsername
        if isOwner {
            bottomButton.setTitle("Destroy group", for: .normal)
        }else {
            bottomButton.setTitle("Leave group", for: .normal)
        }
        groupIdLabel.text = group?.groupId
        subjectLabel.text = group?.subject
        descriptionLabel.text = group?.description
        ownerLabel.text = group?.owner
        extensionLabel.text = group?.setting.ext

        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            break
        case 1:
            if isOwner || isAdmin{
                // Only owner or admin can change.
                weak var weakSelf = self
                let action = EMAlertAction.defaultAction(title: "Change", handler: { (alertAction) in
                    let action = alertAction as! EMAlertAction
                    let textField = action.alertController?.textFields?.first
                    weakSelf?.showHub(inView: weakSelf?.view, "Uploading...")
                    EMClient.shared().groupManager.updateGroupSubject(textField?.text, forGroup: weakSelf?.group?.groupId, completion: { (result, error) in
                        weakSelf?.hideHub()
                        if error == nil {
                            weakSelf?.group = result
                            weakSelf?.updateGroupInfo()
                            weakSelf?.tableView.reloadData()
                            NotificationCenter.default.post(name: NSNotification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: result)
                        }else {
                            weakSelf?.show((error?.errorDescription)!)
                        }
                    })
                })
                let alert = UIAlertController.textField(withTitle:"Change Subject", item: action, defaultText: group?.subject)
                present(alert, animated: true, completion: nil)
            }
            break
        case 2:
            if isOwner || isAdmin{
                // Only owner or admin can change.
                weak var weakSelf = self
                let action = EMAlertAction.defaultAction(title: "Change", handler: { (alertAction) in
                    let action = alertAction as! EMAlertAction
                    let textField = action.alertController?.textFields?.first
                    weakSelf?.showHub(inView: weakSelf?.view, "Uploading...")
                    EMClient.shared().groupManager.updateDescription(textField?.text, forGroup: weakSelf?.group?.groupId, completion: { (result, error) in
                        weakSelf?.hideHub()
                        if error == nil {
                            weakSelf?.group = result
                            weakSelf?.updateGroupInfo()
                            weakSelf?.tableView.reloadData()
                        }else {
                            weakSelf?.show((error?.errorDescription)!)
                        }
                    })
                })
                let alert = UIAlertController.textField(withTitle:"Change Description", item: action, defaultText: group?.description)
                present(alert, animated: true, completion: nil)
            }
            break
        case 3:
            break
        case 4:
            let groupAnnouncementViewController = EMGroupAnnouncementViewController()
            groupAnnouncementViewController.isCanChange = isOwner || isAdmin ? true : false
            groupAnnouncementViewController.group = group
            navigationController?.pushViewController(groupAnnouncementViewController, animated: true)
            break
        case 5:
            let groupAdminListVC = EMGroupAdminListViewController()
            groupAdminListVC.group = group
            groupAdminListVC.isOwner = isOwner
            groupAdminListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupAdminListVC, animated: true)
            break
        case 6:
            let groupMemberListVC = EMGroupMemberListViewController()
            groupMemberListVC.group = group
            groupMemberListVC.isOwner = isOwner
            groupMemberListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupMemberListVC, animated: true)
            break
        case 7:
            if isOwner || isAdmin{
                // Only owner or admin can change.
                weak var weakSelf = self
                let action = EMAlertAction.defaultAction(title: "Change", handler: { (alertAction) in
                    let action = alertAction as! EMAlertAction
                    let textField = action.alertController?.textFields?.first
                    weakSelf?.showHub(inView: weakSelf?.view, "Uploading...")
                    EMClient.shared().groupManager.updateGroupExt(withId: weakSelf?.group?.groupId, ext: textField?.text, completion: { (result, error) in
                        weakSelf?.hideHub()
                        if error == nil {
                            weakSelf?.group = result
                            weakSelf?.updateGroupInfo()
                            weakSelf?.tableView.reloadData()
                        }else {
                            weakSelf?.show((error?.errorDescription)!)
                        }
                    })
                })
                let alert = UIAlertController.textField(withTitle:"Change Extension", item: action, defaultText: group?.setting.ext)
                present(alert, animated: true, completion: nil)
            }
            break
        case 8:
            let shareFileVC = EMGroupShareFileViewController()
            shareFileVC.group = group
            navigationController?.pushViewController(shareFileVC, animated: true)
            break
        case 9:
            let groupBlackListVC = EMGroupBlackListViewController()
            groupBlackListVC.group = group
            groupBlackListVC.isOwner = isOwner
            groupBlackListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupBlackListVC, animated: true)
            break
        case 10:
            let groupMuteListVC = EMGroupMuteListViewController()
            groupMuteListVC.group = group
            groupMuteListVC.isOwner = isOwner
            groupMuteListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupMuteListVC, animated: true)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isAdmin || isOwner {
            return 55
        }
        
        switch indexPath.row {
        case 0, 1, 2, 3, 4, 5, 6, 8:
            return 55
        default:
            return 0
        }
    }
    
    @IBAction func clearAllMessageAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(KNOTIFICATIONNAME_DELETEALLMESSAGE), object: group?.groupId)
    }
    
    @IBAction func bottomAction(_ sender: UIButton) {
        weak var weakSelf = self
        if isOwner {
            showHub(inView: view, "Dissolution of the group...")
            EMClient.shared().groupManager.destroyGroup(group?.groupId, finishCompletion: { (error) in
                weakSelf?.hideHub()
                if error == nil {
                    NotificationCenter.default.post(name: NSNotification.Name(KEM_END_CHAT), object: nil)
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        } else {
            showHub(inView: view, "Leaving of the group...")
            EMClient.shared().groupManager.leaveGroup(group?.groupId, completion: { (error) in
                weakSelf?.hideHub()
                if error == nil {
                    NotificationCenter.default.post(name: NSNotification.Name(KEM_END_CHAT), object: nil)
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
    }
    
}
