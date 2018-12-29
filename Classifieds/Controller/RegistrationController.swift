//
//  RegistrationController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    
    
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupStackView()
        
    }
    
    let coverPhoto: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "architecture-buildings-cars-1034662")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let fullNameTextfield: CustomTextField = {
        let tf = CustomTextField(padding: 10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Full name"
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.clipsToBounds = true
        tf.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        tf.layer.cornerRadius = 4
        tf.addTarget(self, action: #selector(checkIfFormValid), for: .editingChanged)
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 10)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.clipsToBounds = true
        tf.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        tf.layer.cornerRadius = 4
        tf.addTarget(self, action: #selector(checkIfFormValid), for: .editingChanged)
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
        tf.addTarget(self, action: #selector(checkIfFormValid), for: .editingChanged)
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        button.backgroundColor = .gray
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.setTitle("Go to Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.tintColor = .white
        return button
    }()
    
    @objc func handleLogin() {
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc func checkIfFormValid() {
        
        let isFormValid = fullNameTextfield.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .red
        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .gray
        }
    }
    
    func showProgressHUD(error: Error) {
        handlingRegister.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    let handlingRegister = JGProgressHUD(style: .dark)
    
//    func fetchCurrentUser() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
//            if let error = err {
//                self.showProgressHUD(error: error)
//            }
//            guard let userDictionary = snapshot?.data() else {return}
//            self.user = User(dictionary: userDictionary)
//            print(self.user?.name)
//        }
//    }
    
    
    @objc func handleRegister() {
        print("Handle Register")
        self.handlingRegister.show(in: self.view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let error = err {
                self.showProgressHUD(error: error)
                return
            }
            self.saveUserIntoDatabase()
//            self.fetchCurrentUser()
            self.handlingRegister.textLabel.text = "Registering"
            self.handlingRegister.dismiss(afterDelay: 3, animated: true)
            let tabBarControllr = TabBarControllr()
            self.navigationController?.pushViewController(tabBarControllr, animated: true)
        }
    }
    
    func saveUserIntoDatabase() {
        guard let name = fullNameTextfield.text else {return}
        guard let email = emailTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userData: [String : Any] = ["fullName" : name, "email" : email, "uid" : uid]
        Firestore.firestore().collection("users").document(uid).setData(userData) { (err) in
            if let error = err {
                self.showProgressHUD(error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func setupStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [fullNameTextfield, emailTextField, passwordTextField, registerButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = . vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        view.addSubview(coverPhoto)
        coverPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        coverPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        coverPhoto.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        coverPhoto.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(loginButton)
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}
