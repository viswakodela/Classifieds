//
//  AccountHeader.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/21/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class AccountHeader: UICollectionReusableView {
    
    weak var accountController: AccountCollectionViewController?
    weak var user: User?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 75
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viswajith"
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "viswakodela@gmail.com"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    let numberofPosts: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-trolley-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleNumberOfPosts), for: .touchUpInside)
        return button
    }()
    
    func setupLayout() {
        
        backgroundColor = UIColor(red: 236/255, green: 113/255, blue: 110/255, alpha: 1)
        addSubview(userImageView)
        userImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant:  150).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, emailLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(numberofPosts)
        numberofPosts.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        numberofPosts.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        numberofPosts.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        numberofPosts.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc func handleNumberOfPosts() {
        guard let user = self.user else {return}
        accountController?.pushToUserPosts(user: user)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
