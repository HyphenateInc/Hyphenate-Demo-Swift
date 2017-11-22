//
//  ChatroomsViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/21.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class ChatroomsViewController: EMBaseRefreshTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewDidTriggerHeaderRefresh()
    }
    
    func setupNavBar() {
        title = "Chatrooms"
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGroupList), name: NSNotification.Name(KEM_REFRESH_CHATROOMLIST_NOTIFICATION), object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(KEM_REFRESH_CHATROOMLIST_NOTIFICATION), object: nil)
    }
    
    // MARK: - Action
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
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
        
        (cell as! EMGroupCell).setGroupModel(model: dataArray![indexPath.row] as! IEMConferenceModelDelegate)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatroomModel = dataArray![indexPath.row] as! EMChatroomModel
        let conversation = EMClient.shared().chatManager .getConversation(chatroomModel.id, type: EMConversationTypeChatRoom, createIfNotExist: true)
        var ext = conversation?.ext
        if ext == nil {
            ext = ["subject":chatroomModel.subject ?? chatroomModel.id!]
        }else {
            ext!["subject"] = chatroomModel.subject ?? chatroomModel.id!
        }
        conversation?.ext = ext 
        let chatVC = EMChatViewController(chatroomModel.id!, EMConversationTypeChatRoom)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK - Data
    
    override func tableViewDidTriggerHeaderRefresh() {
        page = 1
        self.fetchChatroomsWith(page: page, isHeader: true)
    }
    
    override func tableViewDidTriggerFooterRefresh() {
        page += 1
        self.fetchChatroomsWith(page: page, isHeader: false)
    }
    
    func fetchChatroomsWith(page: Int, isHeader: Bool) {
        weak var weakSelf = self
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        let pageSize = 50
        EMClient.shared().roomManager.getChatroomsFromServer(withPage: page, pageSize: pageSize) { (aResult, error) in
            MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow, animated: true)
            weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
            if error == nil && aResult != nil {
                let chatrooms = aResult!.list
                if (isHeader) {
                    weakSelf?.dataArray?.removeAll()
                }
                
                for chatroom in chatrooms as! Array<EMChatroom> {
                    let model = EMChatroomModel.createWith(conference: chatroom)
                    weakSelf?.dataArray?.append(model)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if chatrooms!.count < pageSize {
                        self.showRefreshFooter = false
                    }else {
                        self.showRefreshFooter = true;
                    }
                }
                
            }
        }
    }
}
