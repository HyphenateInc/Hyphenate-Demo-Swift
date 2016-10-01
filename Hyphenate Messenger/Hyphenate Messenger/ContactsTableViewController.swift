//
//  ContactsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/27/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK


class ContactsTableViewController:UITableViewController,EMGroupManagerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var dataSource = [AnyObject]()
    var searchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        EMClient.sharedClient().groupManager.removeDelegate(self)
//        EMClient.sharedClient().groupManager.addDelegate(self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "BaseTableViewCell", bundle: nil), forCellReuseIdentifier: BaseTableViewCell.reuseIdentifier())
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        let image = UIImage(named: "iconAdd")
        let imageFrame = CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!)
        let addButton = UIButton(frame: imageFrame)
        addButton.setBackgroundImage(image, forState: .Normal)
        addButton.addTarget(self, action: Selector(addContactAction()), forControlEvents: .TouchUpInside)
        addButton.showsTouchWhenHighlighted = true
        let rightButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightButtonItem
        
        self.reloadDataSource()
    }
    
    func addContactAction() {
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func reloadDataSource(){
        self.dataSource.removeAll()
//        self.dataSource = EMClient.sharedClient().groupManager.getJoinedGroups()
        EMClient.sharedClient().contactManager.getContactsFromServerWithCompletion({ (array, error) in
            self.dataSource = array
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        })
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
        cell.displayNameLabel.text = self.dataSource[indexPath.row] as? String
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}
