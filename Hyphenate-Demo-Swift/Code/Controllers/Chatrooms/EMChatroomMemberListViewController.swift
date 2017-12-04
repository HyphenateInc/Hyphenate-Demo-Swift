//
//  EMChatroomMemberListViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/22.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatroomMemberListViewController: EMChatroomParticipantsViewController {
    
    var cursor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Member List"
    }

    override func contactCellDidLongPressed(model: EMUserModel?) {
        if isOwner == false && isAdmin == false{
            return
        }
        weak var weakSelf = self
        let removeFromGroupAction = EMAlertAction.defaultAction(title: "Remove from group") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.removeMembers([(model?.hyphenateID)!], fromChatroom: weakSelf?.chatroom?.chatroomId, completion: { (result, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.chatroom = result
                    weakSelf?.postNotificationToUpdateChatroomInfo()
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: {
                        return ($0 as! IEMUserModel).hyphenateID == model?.hyphenateID
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
            
        }
        
        let addToAdminAction = EMAlertAction.defaultAction(title: "Add to admin") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.addAdmin(model?.hyphenateID, toChatroom: weakSelf?.chatroom?.chatroomId, completion: { (result, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.chatroom = result
                    weakSelf?.postNotificationToUpdateChatroomInfo()
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: {
                        return ($0 as! IEMUserModel).hyphenateID == model?.hyphenateID
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let muteAction = EMAlertAction.defaultAction(title: "Mute") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.muteMembers([(model?.hyphenateID)!], muteMilliseconds:-1 ,fromChatroom: weakSelf?.chatroom!.chatroomId, completion: { (root, error) in
                weakSelf?.hideHub()
                if error == nil {

                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let moveToBlackList = EMAlertAction.defaultAction(title: "Move to blackList") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.blockMembers([(model?.hyphenateID)!], fromChatroom: weakSelf?.chatroom!.chatroomId, completion: { (result, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.chatroom = result
                    weakSelf?.postNotificationToUpdateChatroomInfo()
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: {
                        return ($0 as! IEMUserModel).hyphenateID == model?.hyphenateID
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        
        let alertController = UIAlertController.alertWith(item: removeFromGroupAction, muteAction,moveToBlackList)
        if isOwner {
            alertController.addAction(addToAdminAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableViewDidTriggerFooterRefresh() {
        fetchPersion(isHeader: false)
        page += 50
    }
    
    override func fetchPersion(isHeader: Bool) {
        weak var weakSelf = self
        weakSelf?.showHub(inView: weakSelf!.view, "Loading...")
        EMClient.shared().roomManager.getChatroomMemberListFromServer(withId: chatroom?.chatroomId, cursor: cursor, pageSize: pageSize) { (result, error) in
            weakSelf?.hideHub()
            weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
            if error == nil {
                if result?.cursor != nil {
                    weakSelf?.cursor = (result?.cursor)!
                }
                if (isHeader) {
                    weakSelf?.dataArray!.removeAll()
                }
                if result?.list != nil {
                    var list = Array<IEMUserModel>()
                    for username in result!.list {
                        list.append(EMUserModel.createWithHyphenateId(hyphenateId: username as! String)!)
                    }
                    weakSelf?.dataArray! = (weakSelf?.dataArray!)! + list
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if result!.list.count < self.pageSize {
                        self.showRefreshFooter = false
                    }else {
                        self.showRefreshFooter = true;
                    }
                }
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
}
