//
//  EMApplyRequestCell.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/26.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit

typealias ApplyCallBack = (_ model: EMApplyModel) -> Void

class EMApplyRequestCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var declineApply: ApplyCallBack?
    var acceptApply: ApplyCallBack?
    
    var _model: EMApplyModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = UITableViewCellAccessoryType.none
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    func set(model: EMApplyModel) {
        _model = model
        let defaultImage = "default_avatar.png"
        if _model?.style == EMApplyStype.contact {
            
        }
    }
}
