//
//  Post.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/28/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class Post {
    
    var title: String?
    var uid: String?
    var description: String?
    var postId: String?
    var price: Int?
    var categoryName: String?
    var location: String?
    
    init() {
        
    }
    
    init(dictionary: [String : Any]) {
        self.postId = dictionary["postId"] as? String
        self.price = dictionary["price"] as? Int
        self.categoryName = dictionary["categoryName"] as? String
        self.location = dictionary["location"] as? String
        self.title = dictionary["title"] as? String
        self.description = dictionary["description"] as? String
        self.uid = dictionary["uid"] as? String
    }
}

