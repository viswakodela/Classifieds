//
//  Message.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/9/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

struct Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.postID == rhs.postID && lhs.chatPartnerId() == rhs.chatPartnerId()
    }
    
    
    var messageText: String?
    var fromId: String?
    var toId: String?
    var timeStamp: Double?
    var postID: String?
    
    init(dictionary: [String : Any]) {
        self.messageText = dictionary["messageText"] as? String
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.timeStamp = dictionary["timeStamp"] as? Double
        self.postID = dictionary["postID"] as? String
    }
    
    func chatPartnerId() -> String {
        var chatPartnerId: String?
        
        if fromId == Auth.auth().currentUser?.uid {
            chatPartnerId = toId
        } else {
            chatPartnerId = fromId
        }
        return chatPartnerId!
    }
    
}
