//
//  FilterTableViewCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/8/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    weak var post: Post! {
        didSet {
            guard let imageUrl = post.imageUrl1, let url = URL(string: imageUrl) else {return}
            imageview.sd_setImage(with: url)
            titleLabel.text = post.title ?? ""
            locationLabel.text = post.location ?? ""
            priceLabel.text = "$\(post.price ?? 0)"
            guard let date = post.date else {return}
            let difference = Date(timeIntervalSinceReferenceDate: date)
            dateLabel.text = "Posted \(difference.timeAgoDisplay())"
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    func setupLayout() {
        
        backgroundColor = .white
        clipsToBounds = true
        addSubview(imageview)
        imageview.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageview.topAnchor).isActive = true
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(priceLabel)
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
