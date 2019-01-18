//
//  UserDefaults.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/18/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    static let savePostKey = "savePostKey"
    
    func savedPosts() -> [Post] {
        
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.savePostKey) else {return [] }
        guard let posts =  try? JSONDecoder().decode([Post].self, from: data) else {return []}
        return posts
    }
}
