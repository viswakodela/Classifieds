//
//  NewPostHeaderCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/26/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class NewPostHeaderCell: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        setupLayout()
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        return label
    }()
    
    fileprivate func setupLayout() {
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
