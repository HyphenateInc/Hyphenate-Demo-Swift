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
    var requestSource = [RequestEntity]()
    var searchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        EMClient.sharedClient().groupManager.removeDelegate(self)
//        EMClient.sharedClient().groupManager.addDelegate(self)
        
        tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier())
        tableView.registerNib(UINib(nibName: "FriendRequestTableViewCell", bundle: nil), forCellReuseIdentifier: FriendRequestTableViewCell.reuseIdentifier())
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        tableView.tableFooterView = UIView()
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        let image = UIImage(named: "iconAdd")
        let rightButtonItem:UIBarButtonItem = UIBarButtonItem(image: image, landscapeImagePhone: image, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ContactsTableViewController.addContactAction))
        navigationItem.rightBarButtonItem = rightButtonItem
    
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshFriendRequests), name: kNotification_conversationUpdated, object: nil)

        self.reloadDataSource()
    }
    
    func addContactAction() {
        
        EMClient.sharedClient().contactManager.addContact("pengpeng1", message: "hey") { (userName, error) in
            print("add friend error \(error)")
        }

    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func reloadDataSource(){
        self.dataSource.removeAll()
//        self.dataSource = EMClient.sharedClient().groupManager.getJoinedGroups()
        if let requestArray =  InvitationManager.sharedInstance.getSavedFriendRequests(EMClient.sharedClient().currentUsername) {
            requestSource = requestArray
        }
        EMClient.sharedClient().contactManager.getContactsFromServerWithCompletion({ (array, error) in
            self.dataSource = array
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        })
    }

    func refreshFriendRequests(){
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if requestSource.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if requestSource.count > 0 {
            switch section {
            case 0:
                return 40
            case 1:
                return 20
            default:
                break
            }
        } else {
            return 0
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if requestSource.count > 0 && section == 0 {
            return "Requests"
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if requestSource.count > 0 {
            switch section {
            case 0:
                let viewName = "requestHeaderView"
                let view: UIView = NSBundle.mainBundle().loadNibNamed(viewName,
                                                                      owner: self, options: nil)[0] as! UIView
                let headerView: requestHeaderView = view as! requestHeaderView
                headerView.requestCount.text = "(\(requestSource.count))"
                return headerView
                
            case 1:
                let frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 20)
                let headerView:UIView = UIView(frame: frame)
                headerView.backgroundColor = UIColor(red: 228.0/255, green: 233.0/255, blue: 236.0/255, alpha: 1.0)
                return headerView
            default:
                break
            }
        }
        
        return UIView()

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if requestSource.count > 0 {
            switch section {
            case 0:
                return requestSource.count
            case 1:
                return dataSource.count
            default:
                break
            }
        } else {
            return dataSource.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if requestSource.count > 0 {
            
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("FriendRequestCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
                cell.usernameLabel.text = requestSource[indexPath.row].applicantUsername
                return cell
                
            case 1:
                if dataSource.count > 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.reuseIdentifier()) as! ContactTableViewCell
                    cell.displayNameLabel.text = self.dataSource[indexPath.row] as? String
                    return cell
                }
                
            default:
                break
            }
        } else if dataSource.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.reuseIdentifier()) as! ContactTableViewCell
            cell.displayNameLabel.text = self.dataSource[indexPath.row] as? String
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    }
        
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if requestSource.count > 0 {
            switch indexPath.section {
            case 0:
                return 60
            case 1:
                return 50
            default:
                break
            }
        } else {
            return 50
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if requestSource.count == 0 || indexPath.section == 1 {
            if let contact = dataSource[indexPath.row] as? String {
                let profileController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
                profileController.username = contact
                self.navigationController!.pushViewController(profileController, animated: true)
            }
        }
    }
    
}
