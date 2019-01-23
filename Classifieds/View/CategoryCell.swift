//
//  CategoryCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    let labels: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 64/255, green: 63/255, blue: 63/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var categoryModel: CategoryModel! {
        didSet {
            imageView.image = categoryModel.image
            labels.text = categoryModel.categoryName
        }
    }
    
    fileprivate func setupViews() {
        
        backgroundColor = .white
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false;
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false;
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        containerView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.75).isActive = true
        
        containerView.addSubview(labels)
        labels.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        labels.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        labels.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        labels.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
