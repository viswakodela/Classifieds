//
//  HomeControllerCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/2/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class HomeControllerCell: UICollectionViewCell {
    
    //MARK: - Property Observer
    var post: Post! {
        didSet {
            guard let imageUrl = post.imageUrl1 else {return}
            let url = URL(string: imageUrl)
            imageview.sd_setImage(with: url)
            priceLabel.text = "$ \(post.price ?? 0)"
            titleLabel.text = "\(self.post.title ?? "")"
        }
    }
    
    //MARK: - Cell Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK:- Layout Properties
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Contraiant Methods
    func setupLayout() {
        
        addSubview(imageview)
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
