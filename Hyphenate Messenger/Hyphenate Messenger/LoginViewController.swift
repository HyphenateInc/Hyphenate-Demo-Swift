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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameTextField: HyphenateTextField!
    @IBOutlet weak var passwordTextField: HyphenateTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        activityIndicator.startAnimating()
        
        EMClient.shared().login(withUsername: userNameTextField.text, password: passwordTextField.text) { (userName : String?, error : EMError?) in
            
            self.activityIndicator.stopAnimating()
            
            if ((error) != nil) {
                let alert = UIAlertController(title:"Login Failure", message: error?.errorDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else if EMClient.shared().isLoggedIn {
                let mainVC = MainViewController()
                HyphenateMessengerHelper.sharedInstance.mainVC = mainVC
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        }
    }
}
