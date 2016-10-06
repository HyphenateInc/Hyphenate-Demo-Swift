//
//  ChatTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/28/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

class ChatTableViewController: EaseMessageViewController,EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showRefreshHeader = true
        self.delegate = self
        self.dataSource = self
        navigationController?.navigationBar.tintColor = UIColor(red: 71.0/255, green: 201/255.0, blue: 5.0/255, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor(red: 250.0/255, green: 251.0/255, blue: 252.0/255, alpha: 1)
    }
    
    // Mark: EaseMessageViewControllerDelegate
    
    func messageViewController(_ viewController: EaseMessageViewController!, canLongPressRowAt indexPath: IndexPath!) -> Bool {
        return false
    }
    
    func messageViewController(_ viewController: EaseMessageViewController!, didSelectAvatarMessageModel messageModel: IMessageModel!) {
        
        let profileController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
        profileController.username = messageModel.message.from
        self.navigationController!.pushViewController(profileController, animated: true)
    }
    
    // Mark: EaseMessageViewControllerDataSource

    func messageViewController(_ viewController: EaseMessageViewController!, modelFor message: EMMessage!) -> IMessageModel! {
       
        let model = EaseMessageModel(message: message)
        model?.avatarImage = UIImage(named: "placeholder")
        model?.failImageName = "imageDownloadFail";
        
        return model;
    }
    
    
}
