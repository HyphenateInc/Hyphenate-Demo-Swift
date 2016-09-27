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

        // Do any additional setup after loading the view.
        
        let contactsViewController: ContactsTableViewController = ContactsTableViewController();
        let contactsRootViewController:UINavigationController = UINavigationController(rootViewController: contactsViewController)
        
        let conversationsViewController:ConversationsTableViewController = ConversationsTableViewController()
        let conversationRootViewController:UINavigationController = UINavigationController(rootViewController: conversationsViewController)
        
        let settingsViewController:SettingsTableViewController = SettingsTableViewController()
        let settingsRootViewController:UINavigationController = UINavigationController(rootViewController: settingsViewController)
        
        self.setViewControllers([contactsRootViewController, conversationRootViewController, settingsRootViewController], animated: true)
        
        let contactsTabItem:UITabBarItem = self.tabBar.items![0]
        contactsTabItem.image = #imageLiteral(resourceName: "contactsTab");
        contactsTabItem.selectedImage = #imageLiteral(resourceName: "contactsTab_selected")
        
        let conversationsTabItem:UITabBarItem = self.tabBar.items![1]
        conversationsTabItem.image = #imageLiteral(resourceName: "chatsTab");
        conversationsTabItem.selectedImage = #imageLiteral(resourceName: "chatsTab_selected")

        let settingsTabItem:UITabBarItem = self.tabBar.items![2]
        settingsTabItem.image = #imageLiteral(resourceName: "settingsTab");
        settingsTabItem.selectedImage = #imageLiteral(resourceName: "settingsTab_selected")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
