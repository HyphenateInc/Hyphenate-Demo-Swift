//
//  ContactsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/27/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK


class ContactsTableViewController:UITableViewController,EMGroupManagerDelegate{

    var dataSource = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        EMClient.sharedClient().groupManager.removeDelegate(self)
//        EMClient.sharedClient().groupManager.addDelegate(self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerNib(UINib(nibName: "BaseTableViewCell", bundle: nil), forCellReuseIdentifier: BaseTableViewCell.reuseIdentifier())
        self.reloadDataSource()
    }
    
    func reloadDataSource(){
        self.dataSource.removeAll()
//        self.dataSource = EMClient.sharedClient().groupManager.getJoinedGroups()
        self.dataSource = EMClient.sharedClient().contactManager.getContacts()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("self.dataSource.count:",self.dataSource.count)
        return self.dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BaseTableViewCell.reuseIdentifier()) as! BaseTableViewCell
        cell.displayNameLabel.text = self.dataSource[indexPath.row] as! String
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}
