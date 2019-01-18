//
//  FourthTableCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class PostDescriptionDetailsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    var post: Post! {
        didSet {
            self.descriptionView.text = post.description
        }
    }
    
    let descriptionView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        //        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.textColor = .gray
        tv.isUserInteractionEnabled = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func setupLayout() {
        addSubview(descriptionView)
        descriptionView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
