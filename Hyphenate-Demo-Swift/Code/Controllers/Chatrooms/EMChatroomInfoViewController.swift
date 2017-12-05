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
    @IBOutlet weak var chatroomSubjectLabel: UILabel!
    @IBOutlet weak var chatroomDescLabel: UILabel!
    @IBOutlet weak var chatroomOccupantCountLabel: UILabel!
    @IBOutlet weak var chatroomOwnerLabel: UILabel!
    @IBOutlet weak var chatroomAdminListLabel: UILabel!
    @IBOutlet weak var chatroomMembersCountLabel: UILabel!
    
    var isOwner = false
    var isAdmin = false
    
    var chatroom: EMChatroom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chatroom Info"
        isOwner = chatroom?.owner == EMClient.shared().currentUsername
        setupBackAction()
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
        isAdmin = (chatroom!.adminList.contains(where: { (username) -> Bool in
            return (username as! String) == EMClient.shared().currentUsername
        }))
        isOwner = chatroom!.owner == EMClient.shared().currentUsername
        
        chatroomSubjectLabel.text = chatroom!.subject
        chatroomDescLabel.text = chatroom!.description
        chatroomOccupantCountLabel.text = String(describing: chatroom!.occupantsCount) + "/" + String(describing: chatroom!.maxOccupantsCount)
        chatroomOwnerLabel.text = chatroom!.owner
        chatroomAdminListLabel.text = String(describing: chatroom!.adminList.count)
        chatroomMembersCountLabel.text = String(describing: chatroom!.occupantsCount - chatroom!.adminList.count - 1 /* owner */)
        print(chatroom!.announcement)
        tableView.reloadData()
    }
    
    func setupUI() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.width(), height: 40))
        btn.setTitle("Leave the chatroom", for: .normal)
        btn.addTarget(self, action: #selector(leaveChatroom), for: .touchUpInside)
        btn.backgroundColor = UIColor.red
        tableView.tableFooterView = btn
    }

    
    @objc func leaveChatroom() {
        if isOwner {
            showHub(inView: UIApplication.shared.keyWindow!, "Destroy the chatroom...")
            weak var weakSelf = self
            EMClient.shared().roomManager.destroyChatroom(chatroom!.chatroomId) { (error) in
                weakSelf?.hideHub()
                if error == nil {
                    NotificationCenter.default.post(name: NSNotification.Name(KEM_END_CHAT), object: weakSelf?.chatroom)
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            }
        } else {
            showHub(inView: UIApplication.shared.keyWindow, "Leaving the chatroom...")
            weak var weakSelf = self
            EMClient.shared().roomManager.leaveChatroom(chatroom!.chatroomId) { (error) in
                weakSelf?.hideHub()
                if error == nil {
                    NotificationCenter.default.post(name: NSNotification.Name(KEM_END_CHAT), object: weakSelf?.chatroom)
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            if isOwner || isAdmin{
                // Only owner or admin can change.
                weak var weakSelf = self
                let action = EMAlertAction.defaultAction(title: "Change", handler: { (alertAction) in
                    let action = alertAction as! EMAlertAction
                    let textField = action.alertController?.textFields?.first
                    weakSelf?.showHub(inView: weakSelf?.view, "Uploading...")
                    EMClient.shared().roomManager.updateSubject(textField?.text, forChatroom: weakSelf?.chatroom?.chatroomId, completion: { (room, error) in
                        weakSelf?.hideHub()
                        if error == nil {
                            weakSelf?.chatroom = room
                            weakSelf?.updateInfo()
                            weakSelf?.tableView.reloadData()
                        }else {
                            weakSelf?.show((error?.errorDescription)!)
                        }
                    })
                })
                let alert = UIAlertController.textField(withTitle:"Change Subject", item: action, defaultText: chatroom?.subject)
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
                    EMClient.shared().roomManager.updateDescription(textField?.text, forChatroom: weakSelf?.chatroom?.chatroomId, completion: { (room, error) in
                        weakSelf?.hideHub()
                        if error == nil {
                            weakSelf?.chatroom = room
                            weakSelf?.updateInfo()
                            weakSelf?.tableView.reloadData()
                        }else {
                            weakSelf?.show((error?.errorDescription)!)
                        }
                    })
                })
                let alert = UIAlertController.textField(withTitle:"Change Description", item: action, defaultText: chatroom?.description)
                present(alert, animated: true, completion: nil)
            }
            break
        case 0, 3, 4: break
        case 5:
            let chatroomAdminListVC = EMChatroomAdminListViewController()
            chatroomAdminListVC.chatroom = chatroom
            chatroomAdminListVC.isOwner = isOwner
            chatroomAdminListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomAdminListVC, animated: true)
            break
        case 6:
            let chatroomMemberListVC = EMChatroomMemberListViewController()
            chatroomMemberListVC.chatroom = chatroom
            chatroomMemberListVC.isOwner = isOwner
            chatroomMemberListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomMemberListVC, animated: true)
            break
        case 7:
            let chatroomAnnouncementViewController = EMChatroomAnnouncementViewController()
            chatroomAnnouncementViewController.isCanChange = isOwner || isAdmin ? true : false
            chatroomAnnouncementViewController.chatroom = chatroom
            navigationController?.pushViewController(chatroomAnnouncementViewController, animated: true)
            break
        case 8:
            let chatroomMuteListVC = EMChatroomMuteListViewController()
            chatroomMuteListVC.chatroom = chatroom
            chatroomMuteListVC.isOwner = isOwner
            chatroomMuteListVC.isAdmin = isAdmin
            navigationController?.pushViewController(chatroomMuteListVC, animated: true)
            break
        case 9:
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
            return 10
        } else {
            return 8
        }
        
    }
}
