//
//  EMShareFileCell.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/4.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

protocol EMShareFileCellDelegate {
    func fileCellDidLongPressed(file: EMGroupSharedFile?)
}

class EMShareFileCell: UITableViewCell {

    var delegate: EMShareFileCellDelegate?
    var _file: EMGroupSharedFile?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        addGestureRecognizer(longPress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setFile(sharefile: EMGroupSharedFile) {
        _file = sharefile
        textLabel?.text = _file?.fileName
        detailTextLabel?.text = String(format: "%.2lf MB", Float(_file?.fileSize ?? 0) / (1024 * 1024))
    }
    
    @objc func longPressAction(lpgr: UILongPressGestureRecognizer) {
        if lpgr.state == .began {
            if delegate != nil {
                delegate?.fileCellDidLongPressed(file: _file)
            }
        }
    }
}
