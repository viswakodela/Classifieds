//
//  Post.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/28/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class Post {
    
    var postId: String?
    var price: Int?
    var categoryName: String?
    var location: String?
    
    init(dictionary: [String : Any]) {
        self.postId = dictionary["postId"] as? String
        self.price = dictionary["price"] as? Int
        self.categoryName = dictionary["categoryName"] as? String
        self.location = dictionary["location"] as? String
    }
    
}

