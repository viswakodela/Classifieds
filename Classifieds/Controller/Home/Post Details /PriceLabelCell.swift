//
//  PriceLabelCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/13/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Lottie
import Firebase

protocol PriceLabelDelegate: class {
    func messageButtonTapped(user: User, post: Post)
}

class PriceLabelCell: UITableViewCell {
    
    //MARK: - Cell Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    //MARK: - Constants
    static let priceLabelUnfavoritesKey =  Notification.Name(rawValue: "priceLabelUnfavoritesKey")  
    
    //MARK: - Variables
    weak var delegate: PriceLabelDelegate?
    
    //MARK: - Observers
    var post: Post! {
        didSet {
            self.priceLabel.text = "$\(post.price ?? 0)"
            guard let date = post.date else {return}
            let difference = Date(timeIntervalSinceReferenceDate: date)
            dateLabel.text = "\(difference.timeAgoDisplay())"
            
            if post.isFavorited == true {
                favoritesButton.setImage(#imageLiteral(resourceName: "icons8-heart-100").withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                favoritesButton.setImage(#imageLiteral(resourceName: "icons8-heart-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
            }
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
    
    lazy var favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-speech-bubble-filled-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleFavorites), for: .touchUpInside)
        return button
    }()
    
    //MARK: -  Methods
    func setupLayout() {
        
        let stackView = UIStackView(arrangedSubviews: [priceLabel, dateLabel, messageButton, favoritesButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Objective Methods
extension PriceLabelCell {
    
    @objc func handleNewMessage() {
        guard let userId = post.uid else {return}
        
        Firestore.firestore().collection("users").document(userId).getDocument { (snap, err) in
            guard let userDictionary = snap?.data() else {return}
            let user = User(dictionary: userDictionary)
            self.delegate?.messageButtonTapped(user: user, post: self.post)
        }
    }
    
    @objc func handleFavorites() {
        
        var savedPosts = UserDefaults.standard.savedPosts()
        if post.isFavorited == false {
            post.isFavorited = true
            
            favoritesButton.setImage(#imageLiteral(resourceName: "icons8-heart-100").withRenderingMode(.alwaysOriginal), for: .normal)
            
            savedPosts.insert(post, at: 0)
            
            guard let postID = post.postId else {return}
            NotificationCenter.default.post(name: PriceLabelCell.priceLabelUnfavoritesKey, object: nil, userInfo: ["postID" : postID])
            
            guard let data = try? JSONEncoder().encode(savedPosts) else {return}
            UserDefaults.standard.set(data, forKey: UserDefaults.savePostKey)
            
        } else {
            
            post.isFavorited = false
            let index = savedPosts.firstIndex { (pst) -> Bool in
                return post.postId == pst.postId
            }
            guard let indx = index else {return}
            favoritesButton.setImage(#imageLiteral(resourceName: "icons8-heart-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
            savedPosts.remove(at: indx)
            
            guard let postID = post.postId else {return}
            NotificationCenter.default.post(name: PriceLabelCell.priceLabelUnfavoritesKey, object: nil, userInfo: ["postID" : postID])
            
            
            guard let data = try? JSONEncoder().encode(savedPosts) else {return}
            UserDefaults.standard.set(data, forKey: UserDefaults.savePostKey)
        }
    }
}
