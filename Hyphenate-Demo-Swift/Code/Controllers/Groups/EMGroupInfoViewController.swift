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
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var announcementLabel: UILabel!
    @IBOutlet weak var adminsCountLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var extensionLabel: UILabel!
    @IBOutlet weak var blacksCountLabel: UILabel!
    @IBOutlet weak var mutesCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group Info"
        isOwner = group?.owner == EMClient.shared().currentUsername
        setupBackAction()
        setupSettingsItem()
        tableView.tableFooterView = UIView()
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
        
        groupIdLabel.text = group?.groupId
        subjectLabel.text = group?.subject
        ownerLabel.text = group?.owner

        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            let groupAnnouncementViewController = EMGroupAnnouncementViewController()
            groupAnnouncementViewController.isCanChange = isOwner || isAdmin ? true : false
            groupAnnouncementViewController.group = group
            navigationController?.pushViewController(groupAnnouncementViewController, animated: true)
            break
        case 4:
            let groupAdminListVC = EMGroupAdminListViewController()
            groupAdminListVC.group = group
            groupAdminListVC.isOwner = isOwner
            groupAdminListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupAdminListVC, animated: true)
            break
        case 5:
            let groupMemberListVC = EMGroupMemberListViewController()
            groupMemberListVC.group = group
            groupMemberListVC.isOwner = isOwner
            groupMemberListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupMemberListVC, animated: true)
            break
        case 6:
            break
        case 7:
            break
        case 8:
            let groupBlackListVC = EMGroupBlackListViewController()
            groupBlackListVC.group = group
            groupBlackListVC.isOwner = isOwner
            groupBlackListVC.isAdmin = isAdmin
            navigationController?.pushViewController(groupBlackListVC, animated: true)
            break
        case 9:
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
        case 0, 1, 2, 3, 4, 5, 7:
            return 55
        default:
            return 0
        }
    }
}
