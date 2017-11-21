//
//  EMGroupCell.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/11/21.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import SDWebImage

class EMGroupCell: UITableViewCell {

    public var model : EMGroupModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGroupModel(model:EMGroupModel) {
        self.model = model
        textLabel?.text = model.subject
        detailTextLabel?.text = model.des
        imageView?.sd_setImage(with: URL(string: model.avatarURLPath!), placeholderImage: UIImage(named:model.avatarImage != nil ? model.avatarImage! : "default_group_avatar"))
    }
}
