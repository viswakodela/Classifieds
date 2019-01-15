//
//  ThirdTableViewCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class ThirdTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    var post: Post! {
        didSet {
            guard let sellerID = post.uid else {return}
            
            Firestore.firestore().collection("users").document(sellerID).getDocument { (snap, err) in
                if let error = err {
                    print(error.localizedDescription)
                }
                guard let snapshot = snap?.data() else {return}
                let user = User(dictionary: snapshot)
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
    
    let sellerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
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
        sellerImageView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 8).isActive = true
        sellerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sellerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sellerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(sellerNameLabel)
        sellerNameLabel.leadingAnchor.constraint(equalTo: sellerImageView.trailingAnchor, constant: 8).isActive = true
        sellerNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8).isActive = true
        sellerNameLabel.centerYAnchor.constraint(equalTo: sellerImageView.centerYAnchor).isActive = true
        sellerNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
