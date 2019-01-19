//
//  PriceLabelCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/13/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Lottie

protocol PriceLabelDelegate: class {
    func messageButtonTapped(post: Post)
}

class PriceLabelCell: UITableViewCell {
    
    //MARK: - Cell Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    //MARK: - Variables
    weak var delegate: PriceLabelDelegate?
    
    //MARK: - Observers
    var post: Post! {
        didSet {
            self.priceLabel.text = "$\(post.price ?? 0)"
            guard let date = post.date else {return}
            let difference = Date(timeIntervalSinceReferenceDate: date)
            dateLabel.text = "\(difference.timeAgoDisplay())"
        }
    }
    
    //MARK: - Layout Properties
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
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
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-speech-bubble-filled-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        return button
    }()
    
    //MARK: -  Methods
    func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [priceLabel, dateLabel, messageButton])
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


extension PriceLabelCell {
    
    @objc func handleNewMessage() {
        delegate?.messageButtonTapped(post: self.post)
    }
}
