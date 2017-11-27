//
//  EMChatroomMuteListViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/23.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatroomMuteListViewController: EMChatroomParticipantsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mute List"
    }
    override func contactCellDidLongPressed(model: EMUserModel?) {
        if isOwner == false  && isAdmin == false{
            return
        }
        let removeAction = EMAlertAction.defaultAction(title: "Unmute") { (action) in
            weak var weakSelf = self
            weakSelf?.showHub(inView: (weakSelf!.view)!, "Uploading...")
            EMClient.shared().roomManager.unmuteMembers([(model?.hyphenateID)!], fromChatroom: self.chatroom!.chatroomId, completion: { (chatroom, error) in
                weakSelf?.hideHub()
                if error == nil {
                    self.postNotificationToUpdateChatroomInfo()
                    let ary = NSMutableArray(array: self.dataArray! as NSArray)
                    ary.remove(model!)
                    self.dataArray = ary as Array
                    self.tableView.reloadData()
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        let alertController = UIAlertController.alertWith(item: removeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableViewDidTriggerFooterRefresh() {
        fetchPersion(isHeader: false)
        page += pageSize
    }
    
    
    override func fetchPersion(isHeader: Bool) {
        weak var weakSelf = self
        weakSelf?.showHub(inView: (weakSelf!.view)!, "Uploading...")
        EMClient.shared().roomManager.getChatroomMuteListFromServer(withId: chatroom?.chatroomId, pageNumber: page, pageSize: pageSize) { (resultList, error) in
            weakSelf?.hideHub()
            weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
            if error == nil {
                if (isHeader) {
                    weakSelf?.dataArray!.removeAll()
                }
                if resultList != nil {
                    var list = Array<IEMUserModel>()
                    for username in resultList! {
                        list.append(EMUserModel.createWithHyphenateId(hyphenateId: username as! String)!)
                    }
                    weakSelf?.dataArray! = (weakSelf?.dataArray!)! + list
                }
                
                DispatchQueue.main.async {
                    weakSelf?.tableView.reloadData()
                    if resultList!.count < self.pageSize {
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
