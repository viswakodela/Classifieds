//
//  NewPostCell1.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/26/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class NewPostCell2: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.4
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.text = "Description"
        tv.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        tv.textColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    
    func setupLayout() {
        
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(textView)
        
        containerView.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
