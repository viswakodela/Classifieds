//
//  PriceLabelCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/13/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class PriceLabelCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    var post: Post! {
        didSet {
            self.priceLabel.text = "$\(post.price ?? 0)"
            guard let date = post.date else {return}
            let difference = Date(timeIntervalSinceReferenceDate: date)
            dateLabel.text = "\(difference.timeAgoDisplay())"
        }
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor(red: 65/255, green: 165/255, blue: 122/255, alpha: 1)
        return label
    }()
    
    func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [priceLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
