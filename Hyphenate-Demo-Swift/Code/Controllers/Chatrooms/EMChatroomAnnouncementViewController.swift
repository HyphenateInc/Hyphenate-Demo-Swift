//
//  EMChatroomAnnouncementViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/27.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatroomAnnouncementViewController: UIViewController {

    var chatroom:EMChatroom?
    var isCanChange = false
    var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.width(), height: view.height()))
        textView?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(textView!)
        view.backgroundColor = UIColor.white
        setupNavBar()
        fetchAnnouncement()
    }
    
    func setupNavBar() {
        title = "Announcement"
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .normal)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        if isCanChange {
            let rightBtn = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeAnnouncement))
            navigationItem.rightBarButtonItem = rightBtn
            textView?.isUserInteractionEnabled = true
        }else {
            textView?.isUserInteractionEnabled = false
        }
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changeAnnouncement() {
        weak var weakSelf = self
        weakSelf?.showHub(inView: (weakSelf?.view)!, "Uploading...")
        EMClient.shared().roomManager.updateChatroomAnnouncement(withId: weakSelf?.chatroom?.chatroomId, announcement: textView?.text
            , completion: { (room, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.chatroom = room
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
        })
    }
    
    func fetchAnnouncement() {
        weak var weakSelf = self
        weakSelf?.showHub(inView: (weakSelf!.view)!, "Fetching...")
        EMClient.shared().roomManager.getChatroomAnnouncement(withId: chatroom?.chatroomId) { (announcement, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.textView?.text = announcement
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
}
