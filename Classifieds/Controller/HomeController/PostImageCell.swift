//
//  PostImageCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/3/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class PostImageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    var image: String? {
        didSet {
            guard let img = image else {return}
            guard let url = URL(string: img) else {return}
            imageview.sd_setImage(with: url)
        }
    }
    
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    func setupImageView() {
        
        addSubview(imageview)
        imageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
