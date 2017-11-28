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
        setupNavBar()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewDidTriggerHeaderRefresh()
    }

    func setupNavBar() {
        title = "Public Groups"
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .normal)
        leftBtn.setImage(UIImage(named:"Icon_Back"), for: .highlighted)
        leftBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func loadPublicGroupsFromServer() {
        self.tableViewDidTriggerHeaderRefresh()
    }
    
    // MARK: - Action
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
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
        /*
        weak var weakSelf = self
 
        if groupModel.group?.setting.style == EMGroupStylePublicJoinNeedApproval {
            let applyJoinAction = EMAlertAction.defaultAction(title: "Send", handler: { (alertAction) in
                let action = alertAction as! EMAlertAction
                let textField = action.alertController?.textFields?.first
                weakSelf?.showHub(inView: weakSelf?.view, "Send group of application......")
                EMClient.shared().groupManager.request(toJoinPublicGroup: groupModel.group?.groupId, message: textField?.text, completion: { (group, error) in
                    weakSelf?.hideHub()
                    if error == nil {
                        
                    }else {
                        weakSelf?.show((error?.errorDescription)!)
                    }
                })
            })
            let alertController = UIAlertController.textField(item: applyJoinAction)
            present(alertController, animated: true, completion: nil)
            
        } else if (groupModel.group?.setting.style == EMGroupStylePublicOpenJoin) {
            let joinAction = EMAlertAction.defaultAction(title: "Join the group") { (action) in
                weakSelf?.showHub(inView: weakSelf?.view, "Joining...")
                EMClient.shared().groupManager.joinPublicGroup(groupModel.group?.groupId, completion: { (group, error) in
                    weakSelf?.hideHub()
                    if error == nil {
                        
                    }else {
                        weakSelf?.show((error?.errorDescription)!)
                    }
                })
            }
            let alertController = UIAlertController.alertWith(item: joinAction)
            present(alertController, animated: true, completion: nil)
        }
         */
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
