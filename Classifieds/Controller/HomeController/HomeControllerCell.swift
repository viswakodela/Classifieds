//
//  HomeControllerCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/2/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import SDWebImage

class HomeControllerCell: UICollectionViewCell {
    
    var post: Post! {
        didSet {
            guard let imageUrl = post.imageUrl1 else {return}
            let url = URL(string: imageUrl)
            imageview.sd_setImage(with: url)
            categoryLabel.text = post.categoryName
            titleLabel.text = post.title
        }
    }
    
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        
        addSubview(imageview)
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
