//
//  EMGroupModel.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/21.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMGroupModel: IEMConferenceModelDelegate {
    var _avatarImage: String?
    var _avatarURLPath: String?
    var group:EMGroup?
    var id: String? {
        get {
            return group?.groupId
        }
    }
    
    var subject: String? {
        get {
            return group?.subject
        }
    }
    
    var des: String? {
        get {
            return group?.description
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
        let groupModel = EMGroupModel();
        if conference is EMGroup {
            groupModel.group = conference as? EMGroup
        }
        return groupModel
    }
}
