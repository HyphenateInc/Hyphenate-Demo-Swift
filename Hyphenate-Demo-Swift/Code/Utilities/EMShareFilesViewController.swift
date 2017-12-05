//
//  EMShareFilesViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/12/5.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit

protocol EMShareFilesVCDelegate {
    func didSelectFile(model: EMShareFileModel)
}

class EMShareFilesViewController: UITableViewController {

    var delegate: EMShareFilesVCDelegate?
    var dataArray = EMShareFilesManager.sharedInstance.localFiles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = "Select file"
        setupBackAction()
    }

    override func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ShareFileCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ShareFileCell")
        }
        cell?.textLabel?.text = dataArray?[indexPath.row].fileName
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        let upLoadAction = EMAlertAction.defaultAction(title: "UpLoad") { (action) in
            weakSelf?.delegate?.didSelectFile(model: (weakSelf?.dataArray?[indexPath.row])!)
            weakSelf?.backAction()
        }
        
        let alertController = UIAlertController.alertWith(item: upLoadAction)
        present(alertController, animated: true, completion: nil)
    }
}
