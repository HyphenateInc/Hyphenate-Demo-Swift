//
//  EMCallBaseViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/6.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit

let kShowCallError = "ShowEMCallError"

protocol EMCallBaseVCDelegate {
    func didHungUp()
    func didAwnser()
    func didReject()
    func didMute()
    func didSpeaker()
}

class EMCallBaseViewController: UIViewController {

    var delegate: EMCallBaseVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showError), name: NSNotification.Name(kShowCallError), object: nil)
    }
    
    @objc func showError(noti: Notification) {
        if noti.object is String {
            show(noti.object as! String)
        }
    }
}
