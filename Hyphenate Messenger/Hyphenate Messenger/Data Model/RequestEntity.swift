//
//  RequestEntity.swift
//  Hyphenate Messenger
//
//  Created by Peng Wan on 10/2/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import Foundation

class RequestEntity: NSObject,NSCoding {
    var applicantUsername = ""
    var applicantNick = ""
    var reason = ""
    var receiverUsername = ""
    var receiverNick = ""
    var style: Int!
    var groupId = ""
    var groupSubject = ""
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(applicantUsername, forKey: "applicantUsername")
        aCoder.encodeObject(applicantNick, forKey: "applicantNick")
        aCoder.encodeObject(reason, forKey: "reason")
        aCoder.encodeObject(receiverUsername, forKey: "receiverUsername")
        aCoder.encodeObject(receiverNick, forKey: "receiverNick")
        aCoder.encodeObject(style, forKey: "style")
        aCoder.encodeObject(groupId, forKey: "groupId")
        aCoder.encodeObject(groupSubject, forKey: "subject")
    }
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.applicantUsername = aDecoder.decodeObjectForKey("applicantUsername") as! String
        self.applicantNick = aDecoder.decodeObjectForKey("applicantNick") as! String
        self.reason = aDecoder.decodeObjectForKey("reason") as! String
        self.receiverUsername = aDecoder.decodeObjectForKey("receiverUsername") as! String
        self.receiverNick = aDecoder.decodeObjectForKey("receiverNick") as! String
        self.style = aDecoder.decodeObjectForKey("style") as! Int
        self.groupId = aDecoder.decodeObjectForKey("groupId") as! String
        self.groupSubject = aDecoder.decodeObjectForKey("subject") as! String
        
    }
}
