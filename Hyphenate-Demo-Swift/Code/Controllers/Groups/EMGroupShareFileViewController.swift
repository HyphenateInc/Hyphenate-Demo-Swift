//
//  EMGroupShareFileViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/4.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

let downloadPath = EMShareFilesManager.sharedInstance.fileDocPath()

class EMGroupShareFileViewController: EMBaseRefreshTableViewController, EMShareFileCellDelegate, EMShareFilesVCDelegate{

    var group: EMGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Share Files"
        setupBackAction()
        setupRightBarButtonItem()
        tableViewDidTriggerHeaderRefresh()
    }
    
    func setupRightBarButtonItem() {
        navigationItem.rightBarButtonItem = {
            let item = UIBarButtonItem(title: "UpLoad", style: .done, target: self, action: #selector(upLoadFile))
            item.tintColor = KermitGreenTwoColor
            return item
        }()
    }
    
    @objc func upLoadFile() {
        let shareFileController = EMShareFilesViewController()
        shareFileController.delegate = self
        let navC = UINavigationController.init(rootViewController: shareFileController)
        present(navC, animated: true, completion: nil)
    }
    
    func didSelectFile(model: EMShareFileModel) {
        weak var weakSelf = self
        let filePath = model.fileURL.path
        EMClient.shared().groupManager.uploadGroupSharedFile(withId: group?.groupId, filePath: filePath, progress: nil) { (shareFile, error) in
            if error == nil {
                weakSelf?.dataArray!.append(shareFile!)
                weakSelf?.tableView.reloadData()
            }else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    func fetchShareFilesFromServer(isHeader: Bool = true) {
        weak var weakSelf = self
        let pageSize = 50
        showHub(inView: weakSelf?.view, "Fetching...")
        EMClient.shared().groupManager.getGroupFileList(withId: group?.groupId, pageNumber: page, pageSize: pageSize) { (files, error) in
            weakSelf?.hideHub()
            weakSelf?.tableViewDidFinishTriggerHeader(isHeader: isHeader)
            if error == nil {
                if isHeader {
                    weakSelf?.dataArray!.removeAll()
                }
                for file in files! {
                    weakSelf?.dataArray!.append(file)
                }
                
                DispatchQueue.main.async {
                    weakSelf?.tableView.reloadData()
                    if (files?.count)! < pageSize {
                        self.showRefreshFooter = false
                    }else {
                        self.showRefreshFooter = true;
                    }
                }
            } else {
                weakSelf?.show((error?.errorDescription)!)
            }
        }
    }
    
    override func tableViewDidTriggerHeaderRefresh() {
        fetchShareFilesFromServer(isHeader: true)
    }
    
    override func tableViewDidTriggerFooterRefresh() {
        fetchShareFilesFromServer(isHeader: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "ShareFilesCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? EMShareFileCell
        if cell == nil {
            cell = EMShareFileCell(style: .value1, reuseIdentifier: cellID)
            cell?.delegate = self
        }
        let file = dataArray![indexPath.row] as! EMGroupSharedFile
        cell?.setFile(sharefile: file)

        return cell!
    }
    
    func fileCellDidLongPressed(file: EMGroupSharedFile?) {
        if file == nil {
            return
        }
        weak var weakSelf = self
        let downloadAction = EMAlertAction.defaultAction(title: "Download") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Download...")
            EMClient.shared().groupManager.downloadGroupSharedFile(withId: weakSelf?.group?.groupId, filePath: downloadPath + file!.fileName, sharedFileId: file!.fileId, progress: { (progress) in
                
            }, completion: { (result, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.show("path: " + downloadPath)
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let removeAction = EMAlertAction.defaultAction(title: "Delete") { (action) in
            weakSelf?.showHub(inView: weakSelf!.view, "Remove...")
            EMClient.shared().groupManager.removeGroupSharedFile(withId: weakSelf?.group?.groupId, sharedFileId: file?.fileId, completion: { (restlt, error) in
                weakSelf?.hideHub()
                if error == nil {
                    weakSelf?.dataArray?.remove(at: (weakSelf?.dataArray?.index(where: {
                        return ($0 as! EMGroupSharedFile).fileId == file?.fileId
                    }))!)
                    weakSelf?.tableView.reloadData()
                }else {
                    weakSelf?.show((error?.errorDescription)!)
                }
            })
        }
        
        let alertController = UIAlertController.alertWith(item: downloadAction, removeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
}
