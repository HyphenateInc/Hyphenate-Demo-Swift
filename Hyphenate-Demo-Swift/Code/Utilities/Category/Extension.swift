//
//  Extension.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/23.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    @nonobjc
    func showAlert(_ message: String){
        showAlert(message, nil)
    }
    
    @nonobjc
    func showAlert(_ message: String, _ delegate: UIAlertViewDelegate?) {
        showAlert(nil, message, delegate)
    }
    
    @nonobjc
    func showAlert(_ title: String, _ message: String) {
        showAlert(title, message, nil)
    }
    
    @nonobjc
    func showAlert(_ title: String?, _ message: String, _ delegate: UIAlertViewDelegate?){
        let alertView = UIAlertView.init(title: title, message: message, delegate: delegate, cancelButtonTitle: "OK")
        alertView.show()
    }
}

extension UIAlertController {
    class func alertWith(item: EMAlertAction..., autoAddCancelAction:Bool = true) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in item {
            action.alertController = alert
            alert.addAction(action)
        }

        if autoAddCancelAction {
            alert.addAction(EMAlertAction.defaultAction(title:"Cancel", handler: nil))
        }
        return alert
    }
    
    class func textField(withTitle title: String? = nil, item: EMAlertAction..., defaultText: String? = nil, autoAddCancelAction:Bool = true) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText;
        }
        
        for action in item {
            action.alertController = alert
            alert.addAction(action)
        }
        
        if autoAddCancelAction {
            alert.addAction(EMAlertAction.defaultAction(title:"Cancel", handler: nil))
        }
        return alert
    }
}

extension EMAlertAction {
    
    class func defaultAction(title: String?, handler: ((UIAlertAction) -> Swift.Void)?) -> EMAlertAction {
        return EMAlertAction(title: title, style: .default, handler: handler)
    }
    
    class func cancelAction(title: String? = nil, handler: ((UIAlertAction) -> Swift.Void)? = nil) -> EMAlertAction {
        return EMAlertAction(title: (title != nil ? title! : "Cancel"), style:.cancel, handler: handler)
    }
}

