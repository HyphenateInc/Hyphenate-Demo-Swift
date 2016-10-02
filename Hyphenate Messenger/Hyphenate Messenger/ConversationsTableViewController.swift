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
    case DeleteConvesationOnly
    case DeleteConvesationWithMessages
}

public protocol ConversationListViewControllerDelegate: class {
    
    func conversationListViewController(conversationListViewController:ConversationsTableViewController, didSelectConversationModel conversationModel: AnyObject)
}

@objc public protocol ConversationListViewControllerDataSource: class {
    
    func conversationListViewController(conversationListViewController: ConversationsTableViewController, modelForConversation conversation: EMConversation) -> AnyObject
    
    optional func conversationListViewController(conversationListViewController:ConversationsTableViewController, latestMessageTitleForConversationModel conversationModel: AnyObject) -> String
    
    optional func conversationListViewController(conversationListViewController: ConversationsTableViewController, latestMessageTimeForConversationModel conversationModel: AnyObject) -> String
}

public class ConversationsTableViewController: UITableViewController, ConversationListViewControllerDelegate, ConversationListViewControllerDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var dataSource = [AnyObject]()
    var searchController : UISearchController!

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        let image = UIImage(named: "iconNewConversation")
        let imageFrame = CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!)
        let newConversationButton = UIButton(frame: imageFrame)
        newConversationButton.setBackgroundImage(image, forState: .Normal)
        newConversationButton.addTarget(self, action: Selector(composeConversationAction()), forControlEvents: .TouchUpInside)
        newConversationButton.showsTouchWhenHighlighted = true
        let rightButtonItem = UIBarButtonItem(customView: newConversationButton)
        navigationItem.rightBarButtonItem = rightButtonItem
        
        self.tableView.registerNib(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine

        reloadDataSource()
    }
    
    func reloadDataSource(){
        self.dataSource.removeAll()
        
        
        dataSource =  EMClient.sharedClient().chatManager.getAllConversations()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    func composeConversationAction() {
        
    }
    
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ConversationTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ConversationTableViewCell
        let conversation:EMConversation = dataSource[indexPath.row] as! EMConversation
        cell.senderLabel.text = conversation.latestMessage.from

        let timeInterval: Double = Double(conversation.latestMessage.timestamp)
        let date = NSDate(timeIntervalSince1970:timeInterval)
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let dateString = formatter.stringFromDate(date)
        cell.timeLabel.text = dateString
        
        let textMessageBody: EMTextMessageBody = conversation.latestMessage.body as! EMTextMessageBody
        cell.lastMessageLabel.text = textMessageBody.text
        
        print("message ext\(conversation.latestMessage.ext)")
        
        return cell
        
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    public func conversationListViewController(conversationListViewController:ConversationsTableViewController, didSelectConversationModel conversationModel: AnyObject)
    {
        
    }
    
    public func conversationListViewController(conversationListViewController: ConversationsTableViewController, modelForConversation conversation: EMConversation) -> AnyObject
    {
        return String()
    }
    
    public func conversationListViewController(conversationListViewController:ConversationsTableViewController, latestMessageTitleForConversationModel conversationModel: AnyObject) -> String
    {
        return String()
    }
    
    public func conversationListViewController(conversationListViewController: ConversationsTableViewController, latestMessageTimeForConversationModel conversationModel: AnyObject) -> String
    {
        return String()
    }
}
