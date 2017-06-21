//
//  UIImage+HeadImage.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/15.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func imageWithUsername(username:String, placeholderImage:UIImage?) {
        var placeholderImage = placeholderImage
        if placeholderImage == nil {
            placeholderImage = UIImage(named: "default_avatar")
        }
        
        let entity = EMUserProfileManager.sharedInstance.getUserProfileByUsername(username: username)
        if entity != nil {
            sd_setImage(with: URL.init(string: (entity?.imageUrl)!), placeholderImage: placeholderImage)
        } else {
            sd_setImage(with: nil, placeholderImage: placeholderImage)
        }
    }
}
