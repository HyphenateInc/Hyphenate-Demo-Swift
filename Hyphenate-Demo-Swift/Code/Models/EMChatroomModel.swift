//
//  EMChatroomModel.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/21.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatroomModel: IEMConferenceModelDelegate {
    var _avatarImage: String?
    var _avatarURLPath: String?
    var chatroom:EMChatroom?
    var id: String? {
        get {
            return chatroom?.chatroomId
        }
    }
    
    var subject: String? {
        get {
            return chatroom?.subject
        }
    }
    
    var des: String? {
        get {
            return chatroom?.description
        }
    }
    
    var avatarImage: String? {
        get {
            return _avatarImage
        }
        
        set {
            _avatarImage = newValue
        }
    }
    
    var avatarURLPath: String? {
        get {
            return (_avatarURLPath != nil) ? _avatarURLPath! : ""
        }
        
        set {
            _avatarURLPath = newValue
        }
    }
    
    static func createWith(conference: Any) -> IEMConferenceModelDelegate {
        let chatroomModel = EMChatroomModel();
        if conference is EMChatroom {
            chatroomModel.chatroom = conference as? EMChatroom
        }
        return chatroomModel
    }
}
