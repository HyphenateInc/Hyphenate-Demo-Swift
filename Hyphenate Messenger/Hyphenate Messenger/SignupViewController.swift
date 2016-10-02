//
//  SignUpViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/12/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signupAction(sender: AnyObject) {
        EMClient.sharedClient().registerWithUsername("pengpeng5", password: "password") { (userID, error) in
            
        }
    }
}
