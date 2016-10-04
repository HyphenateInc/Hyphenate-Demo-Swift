//
//  ConversationsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/27/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

public enum DeleteConvesationType: Int {
    case deleteConvesationOnly
    case deleteConvesationWithMessages
}

public protocol ConversationListViewControllerDelegate: class {
    
    func conversationListViewController(_ conversationListViewController:ConversationsTableViewController, didSelectConversationModel conversationModel: AnyObject)
}

@objc public protocol ConversationListViewControllerDataSource: class {
    
    func conversationListViewController(_ conversationListViewController: ConversationsTableViewController, modelForConversation conversation: EMConversation) -> AnyObject
    
    @objc optional func conversationListViewController(_ conversationListViewController:ConversationsTableViewController, latestMessageTitleForConversationModel conversationModel: AnyObject) -> String
    
    @objc optional func conversationListViewController(_ conversationListViewController: ConversationsTableViewController, latestMessageTimeForConversationModel conversationModel: AnyObject) -> String
}

open class ConversationsTableViewController: UITableViewController, EMChatManagerDelegate,ConversationListViewControllerDelegate, ConversationListViewControllerDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var dataSource = [AnyObject]()
    var searchController : UISearchController!

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        tableView.tableFooterView = UIView()
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        let image = UIImage(named: "iconNewConversation")
        let imageFrame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        let newConversationButton = UIButton(frame: imageFrame)
        newConversationButton.setBackgroundImage(image, for: UIControlState())
        newConversationButton.addTarget(self, action: #selector(ConversationsTableViewController.composeConversationAction), for: .touchUpInside)
        newConversationButton.showsTouchWhenHighlighted = true
        let rightButtonItem = UIBarButtonItem(customView: newConversationButton)
        navigationItem.rightBarButtonItem = rightButtonItem
        
        self.tableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
  
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshDataSource), name: NSNotification.Name(rawValue: kNotification_conversationUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: kNotification_didReceiveMessages), object: nil)
        
        reloadDataSource()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func refresh() {
//        self.refreshAndSortView()
        reloadDataSource()
    }
    
    func refreshDataSource() {
//        self.tableViewDidTriggerHeaderRefresh()
        reloadDataSource()
    }
    
    
    func reloadDataSource(){
        self.dataSource.removeAll()
        
        
        dataSource =  EMClient.shared().chatManager.getAllConversations() as [AnyObject]
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }

    func composeConversationAction() {
        
    }
    
    open func updateSearchResults(for searchController: UISearchController) {
        
    }

    // MARK: - Table view data source

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ConversationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationTableViewCell
        let conversation:EMConversation = dataSource[(indexPath as NSIndexPath).row] as! EMConversation
        cell.senderLabel.text = conversation.latestMessage.from

        let timeInterval: Double = Double(conversation.latestMessage.timestamp)
        let date = Date(timeIntervalSince1970:timeInterval)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let dateString = formatter.string(from: date)
        cell.timeLabel.text = dateString
        
        let textMessageBody: EMTextMessageBody = conversation.latestMessage.body as! EMTextMessageBody
        cell.lastMessageLabel.text = textMessageBody.text
        
        print("message ext\(conversation.latestMessage.ext)")
        
        return cell
        
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let conversation:EMConversation = dataSource[(indexPath as NSIndexPath).row] as? EMConversation {
            let chatController = ChatTableViewController(conversationID: conversation.conversationId, conversationType: conversation.type)
            chatController?.title = conversation.latestMessage.from
            chatController?.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(chatController!, animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setupUnreadMessageCount"), object: nil)
        self.tableView.reloadData()
    }
    
    open func conversationListViewController(_ conversationListViewController:ConversationsTableViewController, didSelectConversationModel conversationModel: AnyObject){
        
        
    }
    
    open func conversationListViewController(_ conversationListViewController: ConversationsTableViewController, modelForConversation conversation: EMConversation) -> AnyObject
    {
        return String() as AnyObject
    }
    
    open func conversationListViewController(_ conversationListViewController:ConversationsTableViewController, latestMessageTitleForConversationModel conversationModel: AnyObject) -> String
    {
        return String()
    }
    
    open func conversationListViewController(_ conversationListViewController: ConversationsTableViewController, latestMessageTimeForConversationModel conversationModel: AnyObject) -> String
    {
        return String()
    }
 
    @nonobjc open func messagesDidReceive(_ aMessages: [AnyObject]!) {
        HyphenateMessengerHelper.sharedInstance.messagesDidReceive(aMessages)
    }
    
    @nonobjc open func didReceiveMessages(_ aMessages: [AnyObject]!) {
        HyphenateMessengerHelper.sharedInstance.messagesDidReceive(aMessages)
    }
    
}
