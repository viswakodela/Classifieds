//
//  ThirdTableViewCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class SellerDetailsCell: UITableViewCell {
    
    weak var postDetails: PostDetailsController?
    var user: User?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    weak var post: Post! {
        didSet {
            guard let sellerID = post.uid else {return}
            
            Database.database().reference().child("users").child(sellerID).observe(.value) { (snap) in
                guard let snapDict = snap.value as? [String : Any] else {return}
                let user = User(dictionary: snapDict)
                self.user = user
                self.sellerNameLabel.text = user.name
                
                if user.profileImage == nil {
                    self.sellerImageView.image = #imageLiteral(resourceName: "icons8-account-filled-100")
                } else {
                    guard let image = user.profileImage, let url = URL(string: image) else {return}
                    self.sellerImageView.sd_setImage(with: url)
                }
            }
        }
    }
    
    lazy var sellerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGestureUser)))
        return iv
    }()
    
    let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    func setupLayout() {
        
        addSubview(sellerImageView)
        sellerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        sellerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        sellerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sellerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(sellerNameLabel)
        sellerNameLabel.leadingAnchor.constraint(equalTo: sellerImageView.trailingAnchor, constant: 8).isActive = true
        sellerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        sellerNameLabel.centerYAnchor.constraint(equalTo: sellerImageView.centerYAnchor).isActive = true
        sellerNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    @objc func handleGestureUser() {
        guard let user = self.user else{return}
        self.postDetails?.handleOpenUserImageTap(user: user)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
