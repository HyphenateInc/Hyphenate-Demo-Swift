//
//  HyphenateMessengerHelper.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/28/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

public enum HIRequestType: Int {
    case HIRequestTypeFriend
    case HIRequestTypeReceivedGroupInvitation
    case HIRequestTypeJoinGroup
}

class HyphenateMessengerHelper: NSObject, EMClientDelegate, EMChatManagerDelegate, EMContactManagerDelegate, EMGroupManagerDelegate, EMChatroomManagerDelegate, EMCallManagerDelegate {

    static let sharedInstance = HyphenateMessengerHelper()
    
    var callTimer : NSTimer?
    
    var mainVC : MainViewController?
    var conversationVC : ConversationsTableViewController?
    var contactVC : ContactsTableViewController?
    var chatVC : ChatTableViewController?
    
    deinit {
        EMClient.sharedClient().removeDelegate(self)
        EMClient.sharedClient().groupManager.removeDelegate(self)
        EMClient.sharedClient().contactManager.removeDelegate(self)
        EMClient.sharedClient().roomManager.removeDelegate(self)
        EMClient.sharedClient().chatManager.removeDelegate(self)
        EMClient.sharedClient().callManager.removeDelegate!(self)
    }
    
    override init() {
        super.init()
        initHelper()
    }
    
    func initHelper() {
        EMClient.sharedClient().addDelegate(self)
        EMClient.sharedClient().groupManager.addDelegate(self)
        EMClient.sharedClient().chatManager.addDelegate(self)
        EMClient.sharedClient().contactManager.addDelegate(self)
        EMClient.sharedClient().roomManager.addDelegate(self)
    
    }
 
    //Syncing data
    
    func loadConversationFromDB() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            var conversations = [EMConversation]()
            
            for (_, value) in EMClient.sharedClient().chatManager.getAllConversations().enumerate() {
                let conversation : EMConversation = value as! EMConversation
                if (conversation.latestMessage == nil) {
                    EMClient.sharedClient().chatManager.deleteConversation(conversation.conversationId, isDeleteMessages: false, completion: nil)
                } else {
                    conversations.append(conversation)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                NSNotificationCenter.defaultCenter().postNotificationName("kNotification_conversationUpdated", object: conversations)
                NSNotificationCenter.defaultCenter().postNotificationName("kNotification_unreadMessageCountUpdated", object: conversations)
            })
        }
    }
    
    func loadGroupFromServer() {
        EMClient.sharedClient().groupManager.getJoinedGroups();
        EMClient.sharedClient().groupManager.getJoinedGroupsFromServerWithCompletion { (groupList, error) in
            if (error==nil) {
                //reload group from contactVC
            }
        }
    }
    
    func loadPushOptions() {
        EMClient.sharedClient().getPushNotificationOptionsFromServerWithCompletion(nil)
    }
    
    //EMClientDelegate
    
    func connectionStateDidChange(aConnectionState: EMConnectionState) {
        
    }
    
    func autoLoginDidCompleteWithError(aError: EMError!) {
        if aError != nil {
            let alert = UIAlertController(title: nil, message: NSLocalizedString("login.errorAutoLogin", comment: ""), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        } else if (EMClient.sharedClient().isConnected) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                let flag: Bool = EMClient.sharedClient().migrateDatabaseToLatestSDK()
                if (flag==true) {
                    self.loadGroupFromServer()
                    self.loadConversationFromDB()
                }
            })
        }
    }
    
    func userAccountDidLoginFromOtherDevice() {
        logout()
        let alert = UIAlertController(title: NSLocalizedString("prompt", comment: "Prompt"), message: NSLocalizedString("loggedIntoAnotherDevice", comment: "your login account has been in other places"), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func userAccountDidRemoveFromServer() {
        logout()
        let alert = UIAlertController(title: NSLocalizedString("prompt", comment: "Prompt"), message: NSLocalizedString("loginUserRemoveFromServer", comment: "your account has been removed from the server side"), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func hangupCallWithReason(reason: EMCallEndReason) {
        
    }
    
    // EMChatManagerDelegate
    
    func conversationListDidUpdate(aConversationList: [AnyObject]!) {
        NSNotificationCenter.defaultCenter().postNotificationName("kNotification_unreadMessageCountUpdated", object: aConversationList)
        
        NSNotificationCenter.defaultCenter().postNotificationName("kNotification_conversationUpdated", object: aConversationList)

    }
    
    func cmdMessagesDidReceive(aCmdMessages: [AnyObject]!) {
       
        NSNotificationCenter.defaultCenter().postNotificationName("kNotification_didReceiveCmdMessages", object: aCmdMessages)

    }
    
    func messagesDidReceive(aMessages: [AnyObject]!) {
        
        var isRefreshCons = true
        
        for(_, value) in aMessages.enumerate() {
            let message : EMMessage = value as! EMMessage
            let needShowNotif = (message.chatType != EMChatTypeChat) ? needShowNotification(message.conversationId) : true
            if (needShowNotif) {
                NSNotificationCenter.defaultCenter().postNotificationName("didReceiveMessages", object: message)
            }
            
            if (chatVC == nil) {
                chatVC = getCurrentChatView()
            }
            
            var isSameConversation = false
            if (chatVC != nil) {
                isSameConversation = message.conversationId == chatVC?.conversation.conversationId
            }
            
            if (chatVC==nil || isSameConversation==false) {
                
                NSNotificationCenter.defaultCenter().postNotificationName("didReceiveMessages", object: message)
            NSNotificationCenter.defaultCenter().postNotificationName("kNotification_unreadMessageCountUpdated", object: nil)
                return
            }
            
            if (isSameConversation==true) {
                isRefreshCons = false
            }
        }
        
        if isRefreshCons {
            
            NSNotificationCenter.defaultCenter().postNotificationName("didReceiveMessages", object: aMessages[0])

            NSNotificationCenter.defaultCenter().postNotificationName("kNotification_unreadMessageCountUpdated", object: nil)

        }
    }
    
    // EMGroupManagerDelegate
    
    func didLeaveGroup(aGroup: EMGroup!, reason aReason: EMGroupLeaveReason) {
        
        var str : String? = nil
        
        if aReason == EMGroupLeaveReasonBeRemoved {
            str = "You are kicked out from group: \(aGroup.subject) [\(aGroup.groupId)]"
        } else if aReason == EMGroupLeaveReasonDestroyed {
            str = "Group: \(aGroup.subject) [\(aGroup.groupId)] is destroyed"
        }
        
        if (str?.characters.count)! > 0 {
            let alert = UIAlertController(title: nil, message: str, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
        
        var viewControllers = self.mainVC?.navigationController?.viewControllers
        var chatViewController : ChatTableViewController? = nil
        for(_, value) in (viewControllers?.enumerate())! {
            if value is ChatTableViewController {
                let viewController = value as! ChatTableViewController
                if aGroup.groupId == viewController.conversation.conversationId {
                    chatViewController = viewController
                    break
                }
            }
        }
        
        if chatViewController != nil {
            for (index, value) in (viewControllers?.enumerate())! {
                if value == chatViewController {
                    viewControllers?.removeAtIndex(index)
                }
            }
        }
        
        if (viewControllers?.count)! > 0 {
            mainVC?.navigationController?.setViewControllers([(viewControllers?[0])!], animated: true)
        } else {
            mainVC?.navigationController?.setViewControllers(viewControllers!, animated: true)
        }
    }
    
    func joinGroupRequestDidReceive(aGroup: EMGroup!, user aUsername: String!, reason aReason: String!) {
        
        if !(aGroup != nil) || !(aUsername != nil) {
            return
        }
        var reasonString = aReason
        
        if !(reasonString != nil) || reasonString?.characters.count == 0 {
            reasonString = NSLocalizedString("group.joinRequest", comment: "\(aUsername) requested to join the group \'\(aGroup.subject)\'")
        } else {
            reasonString = NSLocalizedString("group.joinRequestWithName", comment: "\(aUsername) requested to join the group \'\(aGroup.subject)\': \(aReason)")
        }
        
        let requestDict : [String:AnyObject] = ["title": aGroup.subject, "groupId": aGroup.groupId, "username":aUsername, "groupname":aGroup.subject, "applyMessage":reasonString, "requestType":HIRequestType.HIRequestTypeJoinGroup.rawValue]
        
//        [[FriendRequestViewController shareController] addNewRequest:requestDict];
//        
//        if (self.mainVC) {
//            
//            #if !TARGET_IPHONE_SIMULATOR
//                [self.mainVC playSoundAndVibration];
//            #endif
//        }
        NSNotificationCenter.defaultCenter().postNotificationName("kNotification_didReceiveRequest", object: requestDict)
    }
    
    func didJoinGroup(aGroup: EMGroup!, inviter aInviter: String!, message aMessage: String!) {
        
        let alert = UIAlertController(title:NSLocalizedString("prompt", comment: "prompt"), message: "\(aInviter) invite you to group: \(aGroup.subject) [\(aGroup.groupId)]", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func joinGroupRequestDidDecline(aGroupId: String!, reason aReason: String!) {
        
        var reasonString = aReason
        
        if (reasonString != nil || reasonString.characters.count == 0) {
            reasonString = NSLocalizedString("group.joinRequestDeclined", comment: "be declined to join group \'\(aGroupId)\'")
        }
        
        let alert = UIAlertController(title:NSLocalizedString("prompt", comment: "prompt"), message: reasonString, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func joinGroupRequestDidApprove(aGroup: EMGroup!) {
        let alert = UIAlertController(title:NSLocalizedString("prompt", comment: "prompt"), message: NSLocalizedString("group.agreedAndJoined", comment: "agreed to join the group of \'\(aGroup.subject)\'"), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func groupInvitationDidReceive(aGroupId: String!, inviter aInviter: String!, message aMessage: String!) {
        if (aGroupId == nil || aInviter == nil) {
            return;
        }
        
        let requestDict : [String:AnyObject] = ["title": "", "groupId": aGroupId, "username":aInviter, "groupname":"", "applyMessage":aMessage, "requestType":HIRequestType.HIRequestTypeReceivedGroupInvitation.rawValue]
        
//        [[FriendRequestViewController shareController] addNewRequest:requestDict];
//        
//        if ((mainVC) != nil) {
//            
//            #if !TARGET_IPHONE_SIMULATOR
//                [self.mainVC playSoundAndVibration];
//            #endif
//        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("kNotification_didReceiveRequest", object: requestDict)
    }

    //EMContactManagerDelegate
    
    func friendRequestDidApproveByUser(aUsername: String!) {
        
        let alert = UIAlertController(title:nil, message: "\(aUsername) accepted friend request", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func friendRequestDidDeclineByUser(aUsername: String!) {
        
        let alert = UIAlertController(title:nil, message: "\(aUsername) declined friend request", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func stopCallTimer() {
        if (callTimer==nil) {
            return
        }
        callTimer?.invalidate()
        callTimer = nil
    }

    func logout() {
        EMClient.sharedClient().logout(false) { (error) in
            if (error == nil) {
                NSNotificationCenter.defaultCenter().postNotificationName("KNotification_logout", object: nil)
            } else {
                print("Error!!! Failed to logout properly!")
                NSNotificationCenter.defaultCenter().postNotificationName("KNotification_logout", object: nil)
            }
        }
    }
    
    func getCurrentChatView() -> ChatTableViewController? {
        
        let viewControllers = mainVC?.navigationController?.viewControllers
        var chatViewController : ChatTableViewController? = nil
        
        for viewcontroller in viewControllers!{
            if viewcontroller is ChatTableViewController {
                chatViewController = viewcontroller as? ChatTableViewController
                break
            }
        }
        return chatViewController
    }
    
    func needShowNotification(fromChatter:String) -> Bool {
        var ret = true
        let igGroupIds : Array = EMClient.sharedClient().groupManager.getGroupsWithoutPushNotification(nil)
        
        for (_, value) in igGroupIds.enumerate() {
            let str:String = value as! String
            if str == fromChatter {
                ret = false
                break;
            }
        }
        return ret
    }
}



