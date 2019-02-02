//
//  SaveCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/30/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class SaveCell: UITableViewCell {
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = .green
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
