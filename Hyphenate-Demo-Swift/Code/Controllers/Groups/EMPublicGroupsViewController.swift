//
//  EMPublicGroupsViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/28.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate
import MBProgressHUD

class EMPublicGroupsViewController: EMBaseRefreshTableViewController {

    var cursor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Public Groups"
        setupBackAction()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewDidTriggerHeaderRefresh()
    }

    func loadPublicGroupsFromServer() {
        self.tableViewDidTriggerHeaderRefresh()
    }
    
    // MARK: - Action
    
    override func tableViewDidTriggerHeaderRefresh() {
        page = 1
        fetchPublicGroupWith(page: page, isHeader: true)
    }
    
    override func tableViewDidTriggerFooterRefresh() {
        page += 1
        fetchPublicGroupWith(page: page, isHeader: false)
    }
    
    func fetchPublicGroupWith(page: Int, isHeader: Bool) {
        weak var weakSelf = self
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
        let pageSize = 50
        EMClient.shared().groupManager.getPublicGroupsFromServer(withCursor: cursor, pageSize: pageSize) { (result, error) in
            MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow, animated: true)
            weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
            let groupList = result?.list
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
        let storyboard = UIStoryboard.init(name: "PublicGroupInfo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EMPublicGroupInfoViewController") as? EMPublicGroupInfoViewController
        vc?.group = groupModel.group
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
