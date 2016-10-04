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

    @IBAction func signupAction(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        EMClient.shared().register(withUsername: usernameTextfield.text, password: passwordTextfield.text) { (userID, error) in
            
            if ((error) != nil) {
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title:"Registration Failure", message: error?.errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                EMClient.shared().login(withUsername: self.usernameTextfield.text, password: self.passwordTextfield.text, completion: { (userID, error) in
                    if ((error) != nil) {
                        let alert = UIAlertController(title:"Login Failure", message: error?.errorDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    } else if EMClient.shared().isLoggedIn {
                        let mainVC = MainViewController()
                        HyphenateMessengerHelper.sharedInstance.mainVC = mainVC
                        self.navigationController?.pushViewController(mainVC, animated: true)
                    }
                })
            }
        }
    }
}
