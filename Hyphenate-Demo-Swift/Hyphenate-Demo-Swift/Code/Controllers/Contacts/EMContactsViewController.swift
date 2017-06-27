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
    }

    func setupNavigation(_ item: UINavigationItem) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named:"Icon_Add"), for: UIControlState.normal)
        btn.setImage(UIImage(named:"Icon_Add"), for: UIControlState.highlighted)
//        btn.addTarget(self, action: #selector(<#T##@objc method#>), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        item.rightBarButtonItem = rightBarButtonItem
        item.titleView = searchBar
    }
    
    override func tableViewDidTriggerHeaderRefresh() {
        if _isSearchState {
            tableViewDidFinishTriggerHeader(isHeader: true)
            return
        }
        
        EMClient.shared().contactManager.getContactsFromServer { (contactsList, error) in
            if error == nil {
                DispatchQueue.global().async {
                    // TODO
                }
            }else {
                self.tableViewDidFinishTriggerHeader(isHeader: true)
            }
        }
    }
    
    func loadContactFromServer() {
        tableViewDidTriggerHeaderRefresh()
    }
    
    func reloadContacts() {
        let buddyList = EMClient.shared().contactManager.getContacts()
        // TODO
    }
    
    func reloadContactRequests() {
        
    }
    
    func reloadGroupNotifications() {
    
    }
    
    func updateContacts(bubbyList: Array<Any>) {
        let blockList = EMClient.shared().contactManager.getBlackList() as Array
        let contacts = NSMutableArray.init(array: bubbyList)
        for blockId in blockList {
            contacts.remove(blockId)
        }
        sortContacts(contacts: contacts as! Array<String>)
    }
    
    func sortContacts(contacts: Array<String>) {
        
    }

    override func tableViewDidFinishTriggerHeader(isHeader: Bool) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
