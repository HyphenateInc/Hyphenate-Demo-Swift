//
//  EMChatsCell.swift
//  Hyphenate-Demo-Swift
//
//  Created by 杜洁鹏 on 2017/6/14.
//  Copyright © 2017年 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class EMChatsCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unreadLabel: UILabel!
    
    public var model : EMConversationModel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if model?.conversation!.unreadMessagesCount == 0 {
            unreadLabel.isHidden = true
            nameLabel.left(left: 75.0)
            nameLabel.width(width: 170.0)
        }else {
            unreadLabel.isHidden = false
            nameLabel.left(left: 95.0)
            nameLabel.width(width: 150.0)
            unreadLabel.text = "\(model!.conversation!.unreadMessagesCount)"
        }
    }

    func setConversationModel(model:EMConversationModel) {
        self.model = model
        if model.conversation?.type == EMConversationTypeChat{
            headImageView.imageWithUsername(username: model.conversation!.conversationId, placeholderImage: UIImage(named: "default_avatar"))
        } else {
            headImageView.image = UIImage(named: "default_group_avatar")
        }
        
        nameLabel.text = model.title()
        
        let draft : String? = model.conversation!.ext?["Draft"] as? String
        
        contentLabel.text = draft != nil && (draft?.characters.count)! > 0 ? "[草稿]" + _latestMessageTitle(withConversation: model.conversation!)! : _latestMessageTitle(withConversation: model.conversation!)
        
        timeLabel.text = _latestMessageTime(withConversation: model.conversation!)
    }
    
    // MARK: - Private
    func _latestMessageTitle(withConversation coversation :EMConversation) -> String? {
        var latestMsgTitle = ""
        let latestMsg = coversation.latestMessage
        if latestMsg != nil {
            let body = latestMsg!.body
            switch body!.type {
            case EMMessageBodyTypeText:
                // TODO 解析表情
                latestMsgTitle = (body as! EMTextMessageBody).text
                break
            case EMMessageBodyTypeImage:
                latestMsgTitle = "[图片]"
                break
            case EMMessageBodyTypeVoice:
                latestMsgTitle = "[音频]"
                break
            case EMMessageBodyTypeVideo:
                latestMsgTitle = "[视频]"
                break
            case EMMessageBodyTypeLocation:
                latestMsgTitle = "[位置]"
                break
            case EMMessageBodyTypeFile:
                latestMsgTitle = "[文件]"
                break
            default: break
                
            }
        }
        
        return latestMsgTitle
    }
    
    func _latestMessageTime(withConversation conversation :EMConversation) -> String? {
        var latestMsgTime = "";
        let latestMsg = conversation.latestMessage
        if  latestMsg != nil {
            var timeIntervar = latestMsg!.timestamp
            if timeIntervar > 140000000000 {
                timeIntervar = timeIntervar / 1000
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            dateFormatter.locale = Locale.current
            latestMsgTime = dateFormatter.string(from: Date.init(timeIntervalSince1970: Double(timeIntervar)))
        }
        
        return latestMsgTime
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
