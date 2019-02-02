//
//  CategoryModel.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

struct CategoryModel {
    
    var image: UIImage?
    var categoryName: String?
    
    init(image: UIImage, categoryName: String) {
        self.image = image
        self.categoryName = categoryName
    }
    
}
