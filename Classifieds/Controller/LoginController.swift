//
//  LoginController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.clipsToBounds = true
        tf.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        tf.layer.cornerRadius = 4
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.clipsToBounds = true
        tf.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        tf.layer.cornerRadius = 4
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.backgroundColor = .gray
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .white
//        button.isEnabled = false
        return button
    }()
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            let tabBarControllr = TabBarControllr()
            self.present(tabBarControllr, animated: true)
        }
    }
    
    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 166).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
    }
    
}
