//
//  EMContactsViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by dujiepeng on 2017/6/13.
//  Copyright © 2017 dujiepeng. All rights reserved.
//

import UIKit
import Hyphenate

class EMContactsViewController: EMBaseRefreshTableViewController, UISearchBarDelegate{

    lazy var searchBar: UISearchBar = {()-> UISearchBar in
        let _searchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 30));
        _searchBar.placeholder = "Search";
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = false;
        _searchBar.backgroundImage = UIImage .imageWithColor(color: UIColor.white, size: _searchBar.bounds.size);
        _searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 0);
        _searchBar.setSearchFieldBackgroundImage(UIImage.imageWithColor(color: PaleGrayColor, size: _searchBar.bounds.size), for: UIControlState.normal);
        _searchBar.tintColor = AlmostBlackColor;
        return _searchBar;
    }()

    
    var contacts = Array<Any>()
    var contactRequests = Array<Any>()
    var groupNotifications = Array<Any>()
    
    private var _sectionTitles = Array<Any>()
    private var _searchSource = Array<Any>()
    private var _searchResults = Array<Any>()
    private var _isSearchState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge(rawValue: 0);
        tableView.sectionIndexColor = BrightBlueColor
        tableView.sectionIndexBackgroundColor = UIColor.clear
        
        setupNavigationItem(navigationItem: navigationItem)
//        reloadGroupNotifications()
//        reloadContactRequests()
        
        tableViewDidTriggerHeaderRefresh()
    }

    public func setupNavigationItem(navigationItem: UINavigationItem) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.setImage(UIImage(named:"Icon_Add"), for: UIControlState.normal)
        btn.setImage(UIImage(named:"Icon_Add"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(addContactAction), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = searchBar
    }
    
    override func tableViewDidTriggerHeaderRefresh() {
        if _isSearchState {
            tableViewDidFinishTriggerHeader(isHeader: true)
            return
        }
        
        weak var weakSelf = self
        EMClient.shared().contactManager.getContactsFromServer { (contactsList, error) in
            if error == nil {
                DispatchQueue.global().async {
                    weakSelf?.updateContacts(bubbyList: contactsList)
                    weakSelf?.tableViewDidFinishTriggerHeader(isHeader: true)
                    DispatchQueue.main.async {
                        weakSelf?.tableView.reloadData()
                    }
                }
            }else {
                weakSelf?.tableViewDidFinishTriggerHeader(isHeader: true)
            }
        }
    }
    
    func loadContactFromServer() {
        tableViewDidTriggerHeaderRefresh()
    }
    
    func reloadContacts() {
        let buddyList = EMClient.shared().contactManager.getContacts()
        updateContacts(bubbyList: buddyList)
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
            weakSelf?.refreshControl?.endRefreshing()
        }
    }
    
    func reloadContactRequests() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            let contactApplys = EMApplyManager.defaultManager.contactApplys()
            weakSelf?.contactRequests = contactApplys!
            weakSelf?.tableView.reloadData()
            EMChatDemoHelper.shareHelper.setupUnrreatedApplyCount()
        }
    }
    
    func reloadGroupNotifications() {
        weak var weakSelf = self
        DispatchQueue.main.async {
            let groupApplys = EMApplyManager.defaultManager.groupApplys()
            weakSelf?.contactRequests = groupApplys!
            weakSelf?.tableView.reloadData()
            EMChatDemoHelper.shareHelper.setupUnrreatedApplyCount()
        }
    }
    
    func updateContacts(bubbyList: Array<Any>?) {
        let blockList = EMClient.shared().contactManager.getBlackList() as Array
        let contacts = NSMutableArray.init(array: bubbyList!)
        for blockId in blockList {
            contacts.remove(blockId)
        }
        sortContacts(contacts: contacts as! Array<String>)
        weak var weakSelf = self
        EMUserProfileManager.sharedInstance.loadUserProfileInBackgroundWithBuddy(buddyList: contacts as! Array<String>, saveToLocat: true) { (success, error) in
            if success {
                DispatchQueue.global().async {
                    weakSelf?.sortContacts(contacts: contacts as! Array<String>)
                    DispatchQueue.main.async {
                        weakSelf?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func sortContacts(contacts: Array<String>) {
        // TODO
    }

    // MARK: - Action Method
    func addContactAction() {
        let addContactViewController = EMAddContactViewController.init(nibName: "EMAddContactViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: addContactViewController)
        present(nav, animated: true, completion: nil)
    }

}
