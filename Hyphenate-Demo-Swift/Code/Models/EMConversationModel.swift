//
//  EMConversationModel.swift
//  Hyphenate-Demo-Swift
//
//  Created by dujiepeng on 2017/6/14.
//  Copyright © 2017 dujiepeng. All rights reserved.
//

import UIKit
import Hyphenate

class EMConversationModel: NSObject, EMRealtimeSearchUtilDelegate {
    
    var _title:String?
    var conversation:EMConversation?
    
    init(conversation con: EMConversation) {
        conversation = con
        if conversation?.type == EMConversationTypeGroupChat {
            let groups = EMClient.shared().groupManager.getJoinedGroups()
            for group in groups! {
                if conversation?.conversationId == (group as! EMGroup).groupId {
                    _title = (group as! EMGroup).subject
                    break
                }
            }
        }
        
        let subject = con.ext?["subject"] as? String
        if subject != nil {
            _title = subject
        }
        
        if _title?.count == 0 {
            _title = conversation?.conversationId
        }
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle), name: NSNotification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
    }
    
    // todo: update chatvc title when group subject has changed.
    @objc func updateTitle(nofi: NSNotification) {
        
    }
    
    func searchKey() -> String? {
        return title()
    }
    
    func title() -> String? {
        if conversation!.type == EMConversationTypeChat  {
            return EMUserProfileManager.sharedInstance.getNickNameWithUsername(username: conversation!.conversationId)
        } else {
            return _title
        }
    }
    
    func isTop()->Bool {
        if conversation?.ext?["isTop"] != nil {
            let numIsTop = conversation?.ext?["isTop"] as! NSNumber
            return numIsTop.boolValue ? true : false
        }
        
        return false
    }
    
    func setIsTop(isTop: Bool) {
        var dic = conversation?.ext
        if dic == nil {
            dic = Dictionary()
        }
        dic!["isTop"] = NSNumber.init(value: isTop)
        conversation?.ext = dic
    }
    
    func removeComplation (completion aCompletionBlock: @escaping () -> Void){
        EMClient.shared().chatManager.deleteConversation(conversation?.conversationId, isDeleteMessages: true) { (aConversationId, aError) in
           aCompletionBlock()
        }
    }
}
