//
//  EMChatRecordView.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/19.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit

protocol EMChatRecordViewDelegate {
    func didFinish(recordPatch: String, duration: Int)
}

class EMChatRecordView: UIView {
    var delegate: EMChatRecordViewDelegate?
    
    private var _recordTimer: Timer
    private var _recordLength: Int
}
