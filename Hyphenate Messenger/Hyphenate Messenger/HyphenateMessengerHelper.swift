//
//  HyphenateMessengerHelper.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/28/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

class HyphenateMessengerHelper: NSObject, EMClientDelegate, EMChatManagerDelegate, EMContactManagerDelegate, EMGroupManagerDelegate, EMChatroomManagerDelegate, EMCallManagerDelegate {

    static let sharedInstance = HyphenateMessengerHelper()
    
    var callTimer : Timer?
    
    var mainVC : MainViewController?
    var conversationVC : ConversationsTableViewController?
    var contactVC : ContactsTableViewController?
    var chatVC : ChatTableViewController?
    
    deinit {
        EMClient.shared().removeDelegate(self)
        EMClient.shared().groupManager.removeDelegate(self)
        EMClient.shared().contactManager.removeDelegate(self)
        EMClient.shared().roomManager.remove(self)
        EMClient.shared().chatManager.remove(self)
        EMClient.shared().callManager.remove!(self)
    }
    
    override init() {
        super.init()
        initHelper()
    }
    
    func initHelper() {
        EMClient.shared().add(self)
        EMClient.shared().groupManager.add(self)
        
    }
 
    //Syncing data
    
    func loadConversationFromDB() {
        DispatchQueue.global(qos: .default).async {
            
            var conversations = [EMConversation]()
            
            for (_, value) in EMClient.shared().chatManager.getAllConversations().enumerated() {
                let conversation : EMConversation = value as! EMConversation
                if (conversation.latestMessage == nil) {
                    EMClient.shared().chatManager.deleteConversation(conversation.conversationId, isDeleteMessages: false, completion: nil)
                } else {
                    conversations.append(conversation)
                }
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_conversationUpdated"), object: conversations)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: conversations)
            }
        }
    }
    
    func loadGroupFromServer() {
        EMClient.shared().groupManager.getJoinedGroups();
        EMClient.shared().groupManager.getJoinedGroupsFromServer { (groupList, error) in
            if (error==nil) {
                //reload group from contactVC
            }
        }
    }
    
    func loadPushOptions() {
        EMClient.shared().getPushNotificationOptionsFromServer(completion: nil)
    }
    
    //EMClientDelegate
    
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        
    }
    
    func autoLoginDidCompleteWithError(_ aError: EMError!) {
        if aError != nil {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("login.errorAutoLogin", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        } else if (EMClient.shared().isConnected) {
            DispatchQueue.global().async {
                let flag: Bool = EMClient.shared().migrateDatabaseToLatestSDK()
                if (flag==true) {
                    self.loadGroupFromServer()
                    self.loadConversationFromDB()
                }
            }
        }
    }
    
    func userAccountDidLoginFromOtherDevice() {
        logout()
        let alert = UIAlertController(title: NSLocalizedString("prompt", comment: "Prompt"), message: NSLocalizedString("loggedIntoAnotherDevice", comment: "your login account has been in other places"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    func userAccountDidRemoveFromServer() {
        logout()
        let alert = UIAlertController(title: NSLocalizedString("prompt", comment: "Prompt"), message: NSLocalizedString("loginUserRemoveFromServer", comment: "your account has been removed from the server side"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    func hangupCallWithReason(reason: EMCallEndReason) {
        
    }
    
    // EMChatManagerDelegate
    func conversationListDidUpdate(_ aConversationList: [Any]!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: aConversationList)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_conversationUpdated"), object: aConversationList)
    }
    
    func cmdMessagesDidReceive(_ aCmdMessages: [Any]!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_didReceiveCmdMessages"), object: aCmdMessages)
    }
    
    func messagesDidReceive(_ aMessages: [Any]!) {
        var isRefreshCons = true
        
        for(index, value) in aMessages.enumerated() {
            let message : EMMessage = value as! EMMessage
            let needShowNotif = (message.chatType != EMChatTypeChat) ? needShowNotification(fromChatter: message.conversationId) : true
            if (needShowNotif) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveMessages"), object: message)
            }
            
            if (chatVC == nil) {
                chatVC =  getCurrentChatView()
            }
            
            var isSameConversation = false
            if (chatVC != nil) {
                isSameConversation = message.conversationId == chatVC?.conversation.conversationId
            }
            
            if (chatVC==nil || isSameConversation==false) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveMessages"), object: message)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: nil)
                return
            }
            
            if (isSameConversation==true) {
                isRefreshCons = false
            }
        }
        
        if isRefreshCons {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveMessages"), object: aMessages[0])
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: nil)

        }
    }
    
    
    func stopCallTimer() {
        if (callTimer==nil) {
            return
        }
        callTimer?.invalidate()
        callTimer = nil
    }

    func logout() {
        EMClient.shared().logout(false) { (error) in
            if (error == nil) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KNotification_logout"), object: nil)
            } else {
                print("Error!!! Failed to logout properly!")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KNotification_logout"), object: nil)
            }
        }
    }
    
    func getCurrentChatView() -> ChatTableViewController {
        
        let viewControllers = mainVC?.navigationController?.viewControllers
        var chatViewController : ChatTableViewController? = nil
        
        for(_, value) in (viewControllers?.enumerated())! {
            if value is ChatTableViewController {
                chatViewController = value as? ChatTableViewController
                break
            }
        }
        return chatViewController!
    }
    
    func needShowNotification(fromChatter:String) -> Bool {
        var ret = true
        let igGroupIds : Array = EMClient.shared().groupManager.getGroupsWithoutPushNotification(nil)
        
        for (_, value) in igGroupIds.enumerated() {
            let str:String = value as! String
            if str == fromChatter {
                ret = false
                break;
            }
        }
        return ret
    }
}


