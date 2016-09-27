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

        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        EMClient.shared().login(withUsername: userNameTextField.text, password: passwordTextField.text) { (userName : String?, error : EMError?) in
            if ((error) != nil) {
                print("error is \(error?.description)")
            }
            print("is login \(EMClient.shared().isLoggedIn)")
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
