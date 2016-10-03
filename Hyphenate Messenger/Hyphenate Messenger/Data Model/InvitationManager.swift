//
//  InvitationManager.swift
//  Hyphenate Messenger
//
//  Created by Peng Wan on 10/2/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import Foundation
class InvitationManager:NSObject{
    
    var sharedInstance: InvitationManager? = nil
    var defaults: NSUserDefaults!
        
    static let sharedInstance = InvitationManager()
    
    override init() {
        super.init()
        self.defaults = NSUserDefaults.standardUserDefaults()
        
    }
        // MARK: - Data
        
        func addInvitation(requestEntity: RequestEntity, loginUser username: String) {
            if let defalutData = self.defaults.objectForKey(username) as? NSData {
                if var requests = NSKeyedUnarchiver.unarchiveObjectWithData(defalutData) as? [RequestEntity]{
                    requests.append(requestEntity)
                    let data = NSKeyedArchiver.archivedDataWithRootObject(requests)
                    self.defaults.setObject(data, forKey: username)
                }
            }
        }
        
        func removeInvitation(requestEntity: RequestEntity, loginUser username: String) {
            if let defalutData = self.defaults.objectForKey(username) as? NSData{
                if var requests = NSKeyedUnarchiver.unarchiveObjectWithData(defalutData) as? [RequestEntity]{
                    var needDelete: RequestEntity?
                    for request: RequestEntity in requests {
                        if (request.groupId == requestEntity.groupId) && (request.receiverUsername == requestEntity.receiverUsername) {
                            needDelete = request
                        }
                    }
                    if let _ = needDelete{
                        if let index = requests.indexOf({$0 == needDelete!}){
                            requests.removeAtIndex(index)
                            let data = NSKeyedArchiver.archivedDataWithRootObject(requests)
                            self.defaults.setObject(data, forKey: username)
                        }
                    }
                }
            }
        }
        
        func getSavedFriendRequests(username: String) -> [RequestEntity]? {
            if let defalutData = self.defaults.objectForKey(username) as? NSData {
                return NSKeyedUnarchiver.unarchiveObjectWithData(defalutData) as? [RequestEntity]
            }
            return nil
        }
    
}