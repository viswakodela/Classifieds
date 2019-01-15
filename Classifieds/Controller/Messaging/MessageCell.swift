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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    var message: Message! {
        didSet {
            
            guard let id = Auth.auth().currentUser?.uid else {return}
            setupNameAndImage(userId: id)
        }
    }
    
    func setupNameAndImage(userId: String) {
        
        self.messageTextLabel.text = message.messageText
        Firestore.firestore().collection("users").document(userId).getDocument { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let snapshot = snap?.data() else {return}
            let user = User(dictionary: snapshot)
            self.userNameLabel.text = user.name
            if user.profileImage == nil {
                self.imageview.image = #imageLiteral(resourceName: "icons8-account-filled-100")
            }
            guard let imageUrl = user.profileImage, let url = URL(string: imageUrl) else {return}
            self.imageview.sd_setImage(with: url)
        }
        
    }
    
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "kugv iytb"
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "niubaiy  ugwigigfqa iugbsahvb yt tyfusavba yg ybsckwa h yt w7itq h iqfcuy 7twtfwgafuygsauyfu ozubv usg vaui g iyag cqoigeiugeiufgwqygyyiwgviwy  uvwg tg it"
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
        
        bubbleView.addSubview(userNameLabel)
        userNameLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bubbleView.addSubview(messageTextLabel)
        messageTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        messageTextLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        messageTextLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: -8).isActive = true
        messageTextLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8).isActive = true
        
        //        self.sendSubviewToBack(bubbleView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
