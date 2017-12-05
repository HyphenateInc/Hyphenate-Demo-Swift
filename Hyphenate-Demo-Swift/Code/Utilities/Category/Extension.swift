//
//  Extension.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/23.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import Foundation
import MBProgressHUD
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

extension Array {
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
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
            alert.addAction(EMAlertAction.cancelAction())
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
            alert.addAction(EMAlertAction.cancelAction())
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

extension UIViewController {
    
    private struct AssociatedKeys {
        static var hub: MBProgressHUD?
    }
    
    var HUD: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.hub) as? MBProgressHUD
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.hub, newValue as MBProgressHUD?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func showHub(inView view: UIView?,_ hint: String) {
        if view == nil {
            return
        }
        HUD = MBProgressHUD(view: view)
        HUD?.labelText = hint
        view!.addSubview(HUD!)
        HUD?.show(true)
    }
    
    func show(_ hint: String) {
        let view = UIApplication.shared.delegate?.window
        let hub = MBProgressHUD.showAdded(to: view!, animated: true)
        hub?.isUserInteractionEnabled = false
        hub?.mode = MBProgressHUDMode.text
        hub?.labelText = hint
        hub?.margin = 10
        hub?.yOffset = 180
        hub?.removeFromSuperViewOnHide = true
        hub?.hide(true, afterDelay: 2)
    }
    
    func show(hint: String, _ yOffset: Float) {
        let view = UIApplication.shared.delegate?.window
        let hub = MBProgressHUD.showAdded(to: view!, animated: true)
        hub?.isUserInteractionEnabled = false
        hub?.mode = MBProgressHUDMode.text
        hub?.labelText = hint
        hub?.margin = 10
        hub?.yOffset = 180
        hub?.yOffset = hub!.yOffset + yOffset
        hub?.removeFromSuperViewOnHide = true
        hub?.hide(true, afterDelay: 2)
    }
    
    func hideHub() {
        HUD?.hide(true)
    }
}

extension MBProgressHUD {
    class public func showInMainWindow(animated: Bool = true) {
        MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: animated)
    }
    
    class public func hideHubInMainWindow(animated: Bool = true) {
        MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow, animated: animated)
    }
}
