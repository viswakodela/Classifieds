//
//  Post.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/28/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class Post:  Codable {
    
    var title: String?
//    var user: User?
    var uid: String?
    var description: String?
    var postId: String?
    var price: Int?
    var categoryName: String?
    var location: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var imageUrl4: String?
    var imageUrl5: String?
    var imagesArray: [String]?
    var date: Double?
    
    var isFavorited: Bool = false
    
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
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.imageUrl4 = dictionary["imageUrl4"] as? String
        self.imageUrl5 = dictionary["imageUrl5"] as? String
        self.imagesArray = dictionary["imagesArray"] as? [String]
        self.date = dictionary["date"] as? Double
    }
}

//    init?(firebaseDictionary dictionary: [String : Any]) {
//        // guard on mandatory
//        guard let postId = dictionary["postId"] as? String,
//            let price = dictionary["price"] as? Int else {
//            return nil
//        }
//
//        // let my non-mandatory / non-required values be (Swift)optional
//        self.location = dictionary["location"] as? String
//
//        self.postId = postId
//        self.price = price
//    }
