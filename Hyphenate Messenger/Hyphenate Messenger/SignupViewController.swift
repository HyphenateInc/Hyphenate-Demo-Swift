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

    @IBOutlet weak var usernameTextfield: HyphenateTextField!
    @IBOutlet weak var passwordTextfield: HyphenateTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }

    @IBAction func signupAction(sender: AnyObject) {
        activityIndicator.startAnimating()
        EMClient.sharedClient().registerWithUsername(usernameTextfield.text, password: passwordTextfield.text) { (userID, error) in
            
            if ((error) != nil) {
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title:"Registration Failure", message: error?.errorDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            } else {
                EMClient.sharedClient().loginWithUsername(self.usernameTextfield.text, password: self.passwordTextfield.text, completion: { (userID, error) in
                    if ((error) != nil) {
                        let alert = UIAlertController(title:"Login Failure", message: error?.errorDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .Cancel, handler: nil))
                        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                    } else if EMClient.sharedClient().isLoggedIn {
                        let mainVC = MainViewController()
                        HyphenateMessengerHelper.sharedInstance.mainVC = mainVC
                        self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                })
            }
        }
    }
}
