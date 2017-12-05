//
//  EMContactCell.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/26.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import SDWebImage

protocol EMContactCellDelegate {
    func contactCellDidLongPressed(model: EMUserModel?)
}

class EMContactCell: UITableViewCell {

    var delegate: EMContactCellDelegate?
    var _model: EMUserModel?
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = UITableViewCellAccessoryType.none
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        addGestureRecognizer(longPress)
        selectedBackgroundView = {
            let view = UIView(frame:bounds)
            view.backgroundColor = UIColor.white
            return view
        }()
        tintColor = KermitGreenTwoColor
    }
    
    @objc func longPressAction(lpgr: UILongPressGestureRecognizer) {
        if lpgr.state == .began {
            if delegate != nil {
                delegate?.contactCellDidLongPressed(model: _model)
            }
        }
    }

    func set(model: EMUserModel) {
        if _model != model {
            _model = model
        }
        
        nicknameLabel.text = _model?.nickname
        avatarImage.image = _model?.defaultAvatarImage
        if _model?.avatarURLPath != nil {
            avatarImage.sd_setImage(with: URL(string: (_model?.avatarURLPath)!), placeholderImage: _model?.defaultAvatarImage)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
