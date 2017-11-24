//
//  ChatroomInfoViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/22.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatroomInfoViewController: UITableViewController {

    
    @IBOutlet weak var chatroomIdLabel: UILabel!
    @IBOutlet weak var chatroomDescLabel: UILabel!
    @IBOutlet weak var chatroomOccupantCountLabel: UILabel!
    @IBOutlet weak var chatroomOwnerLabel: UILabel!
    @IBOutlet weak var chatroomAdminListLabel: UILabel!
    @IBOutlet weak var chatroomMembersCountLabel: UILabel!
    @IBOutlet weak var chatroomAmmouncementLabel: UILabel!
    
    var isOwner = false
    var isAdmin = false
    
    var chatroom: EMChatroom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chatroom Info"
        let currentUsername = EMClient.shared().currentUsername
        isOwner = chatroom?.owner == currentUsername

        setupUI()
        fetchChatroomInfo()
        chatroomIdLabel.text = chatroom?.chatroomId
        
         NotificationCenter.default.addObserver(self, selector: #selector(updateChatroomInfo), name: NSNotification.Name(rawValue:KEM_REFRESH_CHATROOM_INFO), object: nil)
    }
    
    @objc func updateChatroomInfo(withNoti noti: NSNotification) {
        if noti.object != nil && noti.object is EMChatroom {
            let room = noti.object as! EMChatroom
            if room.chatroomId == chatroom?.chatroomId {
                fetchChatroomInfo()
            }
        }
    }
    
    func fetchChatroomInfo() {
        weak var weakSelf = self
        weakSelf?.showHub(inView: view, "Fetching...")
        EMClient.shared().roomManager .getChatroomSpecificationFromServer(withId: chatroom!.chatroomId) { (room, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.chatroom = room
                weakSelf?.updateInfo()
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    func updateInfo() {
        self.isAdmin = (chatroom!.adminList.contains(where: { (username) -> Bool in
            return (username as! String) == EMClient.shared().currentUsername
        }))
        self.chatroomDescLabel.text = chatroom!.description
        self.chatroomOccupantCountLabel.text = String(describing: chatroom!.occupantsCount) + "/" + String(describing: chatroom!.maxOccupantsCount)
        self.chatroomOwnerLabel.text = chatroom!.owner
        self.chatroomAdminListLabel.text = String(describing: chatroom!.adminList.count)
        self.chatroomMembersCountLabel.text = String(describing: chatroom!.occupantsCount - chatroom!.adminList.count - 1 /* owner */)
        self.chatroomAmmouncementLabel.text = chatroom!.announcement
        self.tableView.reloadData()
    }
    
    func setupUI() {
        
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .normal)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.width(), height: 40))
        btn.setTitle("Leave the chatroom", for: .normal)
        btn.addTarget(self, action: #selector(leaveChatroom), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        tableView.tableFooterView = btn
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func leaveChatroom() {
        showHub(inView: UIApplication.shared.keyWindow!, "Leaving the chatroom...")
        weak var weakSelf = self
        EMClient.shared().roomManager.leaveChatroom(chatroom!.chatroomId) { (error) in
            weakSelf?.hideHub()
            if error == nil {
                
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0, 1, 2, 3: break
        case 4:
            let chatroomAdminListVC = EMChatroomAdminListViewController()
            chatroomAdminListVC.chatroom = chatroom
            chatroomAdminListVC.isOwner = isOwner
            chatroomAdminListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomAdminListVC, animated: true)
            break
        case 5:
            let chatroomMemberListVC = EMChatroomMemberListViewController()
            chatroomMemberListVC.chatroom = chatroom
            chatroomMemberListVC.isOwner = isOwner
            chatroomMemberListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomMemberListVC, animated: true)
            break
        case 6:
            if isOwner || isAdmin{
                // Only owner or admin can change announcement.
                weak var weakSelf = self
                let action = EMAlertAction.defaultAction(title: "Change", handler: { (alertAction) in
                    let action = alertAction as! EMAlertAction
                    let textField = action.alertController?.textFields?.first
                    weakSelf?.showHub(inView: (weakSelf?.view)!, "Uploading...")
                    EMClient.shared().roomManager.updateChatroomAnnouncement(withId: weakSelf?.chatroom?.chatroomId, announcement: textField?.text
                    , completion: { (room, error) in
                        weakSelf?.hideHub()
                        if error == nil {
                            weakSelf?.chatroom = room
                            weakSelf?.tableView.reloadData()
                        }else {
                            weakSelf?.show((error?.errorDescription)!)
                        }
                        
                   })
                })
                let alert = UIAlertController.textField(withTitle:"Change Announcement", item: action, defaultText: chatroom?.announcement)
                present(alert, animated: true, completion: nil)
            }
            break
        case 7:
            let chatroomMuteListVC = EMChatroomMuteListViewController()
            chatroomMuteListVC.chatroom = chatroom
            chatroomMuteListVC.isOwner = isOwner
            chatroomMuteListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomMuteListVC, animated: true)
            break
        case 8:
            let chatroomBlackListVC = EMChatroomBlackListViewController()
            chatroomBlackListVC.chatroom = chatroom
            chatroomBlackListVC.isOwner = isOwner
            chatroomBlackListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomBlackListVC, animated: true)
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAdmin || isOwner{
            return 9
        } else {
            return 7
        }
        
    }
}
