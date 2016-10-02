//
//  EMSearchBar.swift
//  Hyphenate Messenger
//
//  Created by Peng Wan on 9/29/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import Foundation
import UIKit

class EMSearchBar:UISearchBar{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for subView: UIView in self.subviews {
            if (subView.isKindOfClass(NSClassFromString("UISearchBarBackground")!)) {
                subView.removeFromSuperview()
            }
            if (subView.isKindOfClass(NSClassFromString("UISearchBarTextField")!)) {
                let textField = (subView as! UITextField)
                textField.borderStyle = .None
//                textField.background! = nil
                textField.frame = CGRectMake(8, 8, self.bounds.size.width - 2 * 8, self.bounds.size.height - 2 * 8)
                textField.layer.cornerRadius = 6
                textField.clipsToBounds = true
                textField.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        for subView: UIView in self.subviews {
            if (subView.isKindOfClass(NSClassFromString("UISearchBarBackground")!)) {
                subView.removeFromSuperview()
            }
            if (subView.isKindOfClass(NSClassFromString("UISearchBarTextField")!)) {
                let textField = (subView as! UITextField)
                textField.borderStyle = .None
                //                textField.background! = nil
                textField.frame = CGRectMake(8, 8, self.bounds.size.width - 2 * 8, self.bounds.size.height - 2 * 8)
                textField.layer.cornerRadius = 6
                textField.clipsToBounds = true
                textField.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    func setCancelButtonTitle(title: String) {
        for searchbuttons: UIView in self.subviews {
            if (searchbuttons is UIButton) {
                let cancelButton = (searchbuttons as! UIButton)
                cancelButton.setTitle(title, forState: .Normal)
            }
        }
    }
}