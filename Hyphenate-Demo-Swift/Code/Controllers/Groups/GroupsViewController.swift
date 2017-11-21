//
//  GroupsViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/8/11.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class GroupsViewController: EMBaseRefreshTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavicationItem()
        tableView.delegate = self
        tableView.dataSource = self
        groupList()
    }
    
    func setupNavicationItem() {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.setImage(UIImage(named:"Icon_Add"), for: UIControlState.normal)
        btn.setImage(UIImage(named:"Icon_Add"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(addGroup), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "Groups"
    }
    
    @objc func addGroup() {
    
    }
    
    func groupList() {
        DispatchQueue.global().async {
            var error: EMError?
            EMClient.shared().groupManager.getJoinedGroupsFromServer(withPage: 0, pageSize: -1, error: &error)
        }
    }

}
