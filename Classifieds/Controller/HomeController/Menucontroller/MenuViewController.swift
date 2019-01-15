//
//  MenuViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/7/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    private let menuCellId = "menuCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    var user: User? {
        didSet {
            self.userNameLabel.text = user?.name
            self.userEmailLabel.text = user?.email
            if user?.profileImage == nil {
                userImageView.image = #imageLiteral(resourceName: "icons8-account-filled-100")
            } else {
                guard let url = user?.profileImage, let imageUrl = URL(string: url) else {return}
                userImageView.sd_setImage(with: imageUrl)
            }
        }
    }
    
    let topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    @objc func handleImageTap() {
        print("Tapped")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    func setupLayout() {
        view.addSubview(topContainerView)
        topContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        topContainerView.addSubview(userImageView)
        userImageView.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        topContainerView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        userNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        topContainerView.addSubview(userEmailLabel)
        userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        userEmailLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        userEmailLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor).isActive = true
        userEmailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellId, for: indexPath)
        
        return cell
    }
    
}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.userImageView.image = editedImage
        dismiss(animated: true, completion: nil)
        
        let fileName = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profileImages").child(fileName)
        guard let uploadData = editedImage?.jpegData(compressionQuality: 0.7) else {return}
        storageRef.putData(uploadData, metadata: nil) { (_, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            storageRef.downloadURL(completion: { (url, err) in
                if let error = err {
                    print(error.localizedDescription)
                }
                self.user?.profileImage = url?.absoluteString
                guard let uid = self.user?.uid else {return}
                let postData: [String : Any] = ["profileImage" : self.user?.profileImage, "fullName" : self.user?.name, "uid" : self.user?.uid, "email" : self.user?.email]
                Firestore.firestore().collection("users").document(uid).setData(postData, completion: { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }
                })
            })
        }
    }
}
