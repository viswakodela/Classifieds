//
//  MessageCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/13/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    
    //MARK: - Cell Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    //MARK: - Property Observer
    var message: Message! {
        didSet {
            
            self.messageTextLabel.text = self.message.messageText
            DispatchQueue.main.async {
                
                guard let fromId = self.message.fromId else {return}
                self.setupNameAndImage(userId: fromId)
            }
                
                guard let date = self.message.timeStamp else {return}
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let messageDate = Date.init(timeIntervalSinceReferenceDate: date).timeAgoDisplay()
//                let realDate = dateFormatter.string(from: messageDate)
                self.dateLabel.text = messageDate
        }
    }
    
    //MARK: - Layout Properties
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.image = #imageLiteral(resourceName: "icons8-account-filled-100")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    //MARK: - Methods
    func setupNameAndImage(userId: String) {
        
        Database.database().reference().child("users").child(userId).observe(.value) { (snap) in
            guard let snapDict = snap.value as? [String : Any] else {return}
            let user = User(dictionary: snapDict)
            if user.profileImage == nil {
                self.imageview.image = #imageLiteral(resourceName: "icons8-account-filled-100")
            }
            self.userNameLabel.text = user.name
            guard let imageUrl = user.profileImage, let url = URL(string: imageUrl) else {return}
            self.imageview.sd_setImage(with: url)
        }
    }
    
    func setupLayout() {
        
        layer.cornerRadius = 20
        addSubview(imageview)
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageview.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        addSubview(bubbleView)
        bubbleView.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 8).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        bubbleView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        bubbleView.addSubview(userNameLabel)
        userNameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        bubbleView.addSubview(messageTextLabel)
        messageTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        messageTextLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        messageTextLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8).isActive = true
        messageTextLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
