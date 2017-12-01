//
//  EMGroupAdminListViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/1.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMGroupAdminListViewController: EMChatroomParticipantsViewController {

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
            EMClient.shared().groupManager.removeAdmin(model?.hyphenateID, fromGroup: weakSelf?.group?.groupId, completion:  { (result, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.group = result
                    weakSelf?.postNotificationToUpdateGroupInfo()
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: { (indexModel) -> Bool in
                        return (indexModel as! IEMUserModel).hyphenateID == model?.hyphenateID
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else{
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let muteAction = EMAlertAction.defaultAction(title: "Mute") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().groupManager.muteMembers([(model?.hyphenateID)!], muteMilliseconds: -1, fromGroup: weakSelf?.group?.groupId, completion: { (resultGroup, error) in
                weakSelf?.hideHub()
                if error == nil {
                    
                }else{
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let moveToBlackList = EMAlertAction.defaultAction(title: "Move to blackList") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Uploading...")
            EMClient.shared().groupManager.unblockMembers([(model?.hyphenateID)!], fromGroup: weakSelf?.group!.groupId, completion: { (result, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.group = result
                    weakSelf?.postNotificationToUpdateGroupInfo()
                    let ary = NSMutableArray(array: self.dataArray! as NSArray)
                    ary.remove(model!)
                    weakSelf?.dataArray = ary as Array
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
        self.showHub(inView: view, "Uploading...")
        weak var weakSelf = self
        EMClient.shared().groupManager.getGroupSpecificationFromServer(withId: group!.groupId) { (result, error) in
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
