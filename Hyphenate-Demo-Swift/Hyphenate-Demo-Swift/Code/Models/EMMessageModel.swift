//
//  EMMessageModel.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/19.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMMessageModel: NSObject {
    var message: EMMessage?
    var isPlaying: Bool = false
    
    init(withMesage msg: EMMessage) {
        message = msg
    }
}
