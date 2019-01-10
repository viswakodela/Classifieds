//
//  CollectionsCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CollectionsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        setupView()
        
    }
    
    var categoryModel: CategoryModel! {
        didSet {
            imageView.image = categoryModel!.image
            categoryLabel.text = categoryModel!.categoryName
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.63
        view.backgroundColor = .black
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    fileprivate func setupView() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        imageView.addSubview(view)
        view.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        
        imageView.addSubview(categoryLabel)
        categoryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
