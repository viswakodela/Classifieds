//
//  BottomControllerCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/5/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class BottomControllerCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLaout()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.2
        clipsToBounds = true
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }
    
    var post: Post? {
        didSet {
            guard let imageString = post?.imageUrl1, let url = URL(string: imageString) else {return}
            imageview.sd_setImage(with: url)
            titleLabel.text = post?.title
            priceLabel.text = "$\(post?.price ?? 0)"
            descriptionView.text = post?.description
        }
    }
    
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "architecture-buildings-cars-1034662")
        return iv
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = "klsbaiubiuasb"
        return label
    }()
    
    let descriptionView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.numberOfLines = 0
        tv.textColor = .gray
        tv.text = "lihsaoubneursv"
        tv.sizeToFit()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupLaout() {
        
        addSubview(imageview)
        imageview.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        addSubview(priceLabel)
        priceLabel.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 8).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(descriptionView)
        descriptionView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        descriptionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
