//
//  EMMemberCollectionViewCell.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/29.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit

class EMMemberCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var userModel: IEMUserModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
    }
    
    func setupModel(model: IEMUserModel?) {
        userModel = model
        if (model != nil) {
            imageView.sd_setImage(with: URL(string: model!.avatarURLPath), placeholderImage: model!.defaultAvatarImage)
            nameLabel.text = model?.nickname
        } else {
            imageView.image = UIImage(named: "Button_Add Member")
            nameLabel.text = ""
        }
    }
}
