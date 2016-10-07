//
//  MainViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/27/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let contactsViewController: ContactsTableViewController = ContactsTableViewController();
        let contactsRootViewController:UINavigationController = UINavigationController(rootViewController: contactsViewController)
        
        let conversationsViewController:ConversationsTableViewController = ConversationsTableViewController()
        let conversationRootViewController:UINavigationController = UINavigationController(rootViewController: conversationsViewController)
        
        let settingsViewController:SettingsTableViewController = SettingsTableViewController()
        let settingsRootViewController:UINavigationController = UINavigationController(rootViewController: settingsViewController)
        
        self.setViewControllers([contactsRootViewController, conversationRootViewController, settingsRootViewController], animated: true)
        
        let contactsTabItem:UITabBarItem = self.tabBar.items![0]
        contactsTabItem.image = UIImage(named:  "contactsTab")
        contactsTabItem.selectedImage = UIImage(named:  "contactsTab_selected")
        contactsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
        
        let conversationsTabItem:UITabBarItem = self.tabBar.items![1]
        conversationsTabItem.image = UIImage(named:  "chatsTab")
        conversationsTabItem.selectedImage = UIImage(named:  "chatsTab_selected")
        conversationsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);

        let settingsTabItem:UITabBarItem = self.tabBar.items![2]
        settingsTabItem.image = UIImage(named:  "settingsTab")
        settingsTabItem.selectedImage = UIImage(named:  "settingsTab_selected")
        settingsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);

        UITabBar.appearance().tintColor = UIColor(red: 77.0/255.0, green: 195.0/255.0, blue: 0, alpha: 1.0)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        updateUnreadMessageCount
//    }
//    
//    - (void)updateUnreadMessageCount:(NSNotification *)notification
//    {
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    
//    NSInteger unreadCount = 0;
//    for (EMConversation *conversation in conversations) {
//    unreadCount += conversation.unreadMessagesCount;
//    }
//    
//    if (self.chatListVC) {
//    
//    if (unreadCount > 0) {
//    self.chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", (int)unreadCount];
//    }
//    else {
//    self.chatListVC.tabBarItem.badgeValue = nil;
//    }
//    }
//    
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
//    }

    
}
