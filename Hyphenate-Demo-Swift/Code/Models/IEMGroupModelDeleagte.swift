//
//  IEMGroupModelDeleagte.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/21.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

protocol IEMConferenceModelDelegate {
    var id: String? {get}
    var subject: String? {get}
    var des: String? {get}
    var avatarURLPath: String? {get set}
    var avatarImage: String? {get set}
    
    static func createWith(conference: Any) -> IEMConferenceModelDelegate
}

