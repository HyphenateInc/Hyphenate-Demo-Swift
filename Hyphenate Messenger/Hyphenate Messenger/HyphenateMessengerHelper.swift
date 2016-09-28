//
//  HyphenateMessengerHelper.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/28/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

class HyphenateMessengerHelper: NSObject {

    
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
    
}


