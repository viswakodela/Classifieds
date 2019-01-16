//
//  NewPostCell2.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/27/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class NewpostPriceCategoryLocationCell: UITableViewCell {
    
    //MARK: - Custom textField Class
    class CustomizedTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 44)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
    }
    
    //MARK: - Table view Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    //MARK: - LAyout Properties
    let textField: CustomizedTextField = {
        let tf = CustomizedTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter.."
        tf.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return tf
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Methods
    func setupLayout() {
        
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
