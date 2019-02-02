//
//  AccountSettingsCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/22/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class AccountSettingsCell: UICollectionViewCell {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //MARK: - LAyout Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let textField: CustomTextField = {
        let tv = CustomTextField(padding: 4)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 8
        tv.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 0.3
        tv.clipsToBounds = true
        return tv
    }()
    
    //MARK: -  Methods
    func setupView() {
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
