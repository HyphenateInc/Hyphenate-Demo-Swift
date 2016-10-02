//
//  LoginViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/10/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: HyphenateTextField!
    @IBOutlet weak var passwordTextField: HyphenateTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        EMClient.sharedClient().loginWithUsername(userNameTextField.text, password: passwordTextField.text) { (userName : String?, error : EMError?) in
            if ((error) != nil) {
                print("error is \(error?.description)")
            }
            print("is login \(EMClient.sharedClient().isLoggedIn)")
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }
}
