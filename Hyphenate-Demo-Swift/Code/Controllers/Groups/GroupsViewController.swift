//
//  GroupsViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/8/11.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class GroupsViewController: EMBaseRefreshTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
    
        tableViewDidTriggerHeaderRefresh()
    }
    
    func setupNavBar() {
        title = "Groups"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightBtn.setImage(UIImage(named:"Icon_Add"), for: .normal)
        rightBtn.setImage(UIImage(named:"Icon_Add"), for: .highlighted)
        rightBtn.addTarget(self, action: #selector(addGroupAction), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .normal)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func loadGroupsFromServer() {
        self.tableViewDidTriggerHeaderRefresh()
    }
    
    func loadGroupsFromCache() {
        let myGroups = EMClient.shared().groupManager.getJoinedGroups()
        dataArray?.removeAll()
        for group in myGroups! {
            let model = EMGroupModel.createWith(conference: group)
            dataArray?.append(model)
        }
        
        tableViewDidTriggerHeaderRefresh()
        tableView.reloadData()
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGroupList), name: NSNotification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(KEM_REFRESH_GROUPLIST_NOTIFICATION), object: nil)
    }
    
    // MARK: - Action
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addGroupAction() {
        
    }
    
    // MARK: - Notification Method
    
    @objc func refreshGroupList(noti: NSNotification) {
        self.loadGroupsFromCache()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "EMGroupCell";
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId);
        if cell == nil {
            cell = Bundle.main.loadNibNamed("EMGroupCell", owner: nil, options: nil)?.first as! EMGroupCell;
        }
        
        (cell as! EMGroupCell).setGroupModel(model: dataArray![indexPath.row] as! EMGroupModel)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let groupModel = dataArray![indexPath.row] as! EMGroupModel
        let chatVC = EMChatViewController(groupModel.id!, EMConversationTypeGroupChat)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK - Data
    
    override func tableViewDidTriggerHeaderRefresh() {
        page = 1
        self.fetchJoinedGroupWith(page: page, isHeader: true)
    }
    
    override func tableViewDidTriggerFooterRefresh() {
        page += 1
        self.fetchJoinedGroupWith(page: page, isHeader: false)
    }
    
    func fetchJoinedGroupWith(page: Int, isHeader: Bool) {
        weak var weakSelf = self
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        let pageSize = 50
        EMClient.shared().groupManager.getJoinedGroupsFromServer(withPage: page, pageSize: pageSize) { (groupList, error) in
            MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow, animated: true)
            weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
            if error == nil && groupList != nil {
                if (isHeader) {
                    weakSelf?.dataArray?.removeAll()
                }
                
                for group in groupList as! Array<EMGroup> {
                    let model = EMGroupModel.createWith(conference: group)
                    weakSelf?.dataArray?.append(model)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if groupList!.count < pageSize {
                        self.showRefreshFooter = false
                    }else {
                        self.showRefreshFooter = true;
                    }
                }
                
            }
        }
    }
}
