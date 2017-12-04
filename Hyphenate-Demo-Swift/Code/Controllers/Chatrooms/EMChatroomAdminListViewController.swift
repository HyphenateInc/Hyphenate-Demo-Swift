//
//  EMChatroomAdminListViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/22.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatroomAdminListViewController: EMChatroomParticipantsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin List"
    }
    
    override func contactCellDidLongPressed(model: EMUserModel?) {
        if isOwner == false {
            return
        }
        weak var weakSelf = self
        let removeAdminAction = EMAlertAction.defaultAction(title: "Remove from Admin") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.removeAdmin(model?.hyphenateID, fromChatroom: weakSelf?.chatroom?.chatroomId, completion: { (room, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.chatroom = room
                    weakSelf?.postNotificationToUpdateChatroomInfo()
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: {
                        return ($0 as! IEMUserModel).hyphenateID == model?.hyphenateID
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else{
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let muteAction = EMAlertAction.defaultAction(title: "Mute") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.muteMembers([(model?.hyphenateID)!], muteMilliseconds:-1 ,fromChatroom: weakSelf?.chatroom!.chatroomId, completion: { (root, error) in
                weakSelf?.hideHub()
                if error == nil {

                }else{
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let moveToBlackList = EMAlertAction.defaultAction(title: "Move to blackList") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().roomManager.blockMembers([(model?.hyphenateID)!], fromChatroom: weakSelf?.chatroom!.chatroomId, completion: { (room, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.chatroom = room
                    weakSelf?.postNotificationToUpdateChatroomInfo()
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: {
                        return ($0 as! IEMUserModel).hyphenateID == model?.hyphenateID
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else{
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        
        let alertController = UIAlertController.alertWith(item: removeAdminAction, muteAction, moveToBlackList)
        present(alertController, animated: true, completion: nil)
    }
    
    override func fetchPersion(isHeader: Bool) {
        self.showHub(inView: view, "Loading...")
        weak var weakSelf = self
        EMClient.shared().roomManager.getChatroomSpecificationFromServer(withId: chatroom!.chatroomId) { (result, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
                weakSelf?.dataArray!.removeAll()
                var list = Array<IEMUserModel>()
                for username in (result?.adminList)! {
                    list.append(EMUserModel.createWithHyphenateId(hyphenateId: username as! String)!)
                }
                weakSelf?.dataArray! = list
                weakSelf?.tableView.reloadData()
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
}

