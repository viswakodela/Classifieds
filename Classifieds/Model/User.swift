//
//  User.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.uid == rhs.uid
    }
    
    
    var name: String?
    var email: String?
    var uid: String?
    var profileImage: String?
    var recentSearchedCities: [String]?
    
    init() {
        
    }
    
    init(dictionary: [String : Any]) {
        self.name = dictionary["fullName"] as? String
        self.uid = dictionary["uid"] as? String
        self.email = dictionary["email"] as? String
        self.profileImage = dictionary["profileImage"] as? String
    }
    
}
