//
//  NewPostCell2.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/27/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

protocol NewCell2Delegate: class {
    func buttonTapped(indexPath: IndexPath, selector: Selector)
}

class NewPostCell2: UITableViewCell {
    
    static let shared = NewPostCell2()
    
    weak var newPost2Delegate: NewCell2Delegate?
    var indexPath: IndexPath!
    
    let newPostController = NewPostController()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightButton = createButton(selector: #selector(handleRightButton))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .gray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    @objc func handleTextFieldTextChange(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let text = userInfo["text"] else {return}
        rightButton.titleLabel?.text = text as? String
    }
    
    @objc func handleRightButton(selector: Selector) {
        self.newPost2Delegate?.buttonTapped(indexPath: indexPath, selector: selector)
    }
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    func setupLayout() {
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [leftLabel, rightButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        containerView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
