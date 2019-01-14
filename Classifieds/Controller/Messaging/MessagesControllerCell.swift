//
//  MessagesCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/10/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class MessagesControllerCell: UITableViewCell {
    
    var messagesTableController : MessagesTableController?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    var message: Message! {
        didSet {
            
            guard let messageText = message.messageText else {return}
            self.messageLabel.text = messageText
            
            guard let buyserID = message.fromId else {return}
            
            Firestore.firestore().collection("users").document(buyserID).getDocument { (snap, err) in
                if let error = err {
                    print(error.localizedDescription)
                }
                
                guard let userDictionary = snap?.data() else {return}
                let user = User(dictionary: userDictionary)
                self.postTitleLabel.text = user.name
                if user.profileImage == nil {
                    self.imageview.image = #imageLiteral(resourceName: "icons8-account-filled-100")
                }
                guard let imageUrl = user.profileImage, let url = URL(string: imageUrl) else {return}
                self.imageview.sd_setImage(with: url)
            }
        }
    }
    
    
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    func setupLayout() {
        addSubview(imageview)
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        imageview.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        addSubview(postTitleLabel)
        postTitleLabel.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 8).isActive = true
        postTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        postTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        postTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        
        addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: postTitleLabel.leadingAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: postTitleLabel.trailingAnchor).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
