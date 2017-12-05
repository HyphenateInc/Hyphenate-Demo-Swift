 //
//  EMGroupAnnouncementViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/1.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMGroupAnnouncementViewController: UIViewController {

    var group:EMGroup?
    var isCanChange = false
    var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: view.width(), height: view.height()))
        textView?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(textView!)
        view.backgroundColor = UIColor.white
        setupNavBar()
        setupBackAction()
        fetchAnnouncement()
    }
    
    func setupNavBar() {
        title = "Announcement"
        if isCanChange {
            let rightBtn = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeAnnouncement))
            navigationItem.rightBarButtonItem = rightBtn
            rightBtn.tintColor = KermitGreenTwoColor
            textView?.isUserInteractionEnabled = true
        }else {
            textView?.isUserInteractionEnabled = false
        }
    }
    
    @objc func changeAnnouncement() {
        weak var weakSelf = self
        weakSelf?.showHub(inView: (weakSelf?.view)!, "Uploading...")
        EMClient.shared().groupManager.updateGroupAnnouncement(withId: weakSelf?.group?.groupId, announcement: textView?.text) { (resultGroup, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.group = resultGroup
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    func fetchAnnouncement() {
        weak var weakSelf = self
        weakSelf?.showHub(inView: weakSelf!.view, "Fetching...")
        EMClient.shared().groupManager.getGroupAnnouncement(withId: group?.groupId) { (announcement, error) in
            weakSelf?.hideHub()
            if error == nil {
                weakSelf?.textView?.text = announcement
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
}
