//
//  AccountTableViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/21/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class AccountCollectionViewController: UICollectionViewController {
    
    //MARK: - Cell Id's
    private static let accountHeaderCell = "accountHeaderCell"
    private static let collectionCell = "collectionCell"
    private static let logOutButtonCell = "logOutButtonCell"
    
    //MARK: - Variables
    var user: User?
    var logOutButton: UIButton?
    var userImageView: UIImageView?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        navigationBarSetup()
    }
    
    //MARK: - Methods
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    func collectionViewSetup() {
        collectionView.register(AccountHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AccountCollectionViewController.accountHeaderCell)
        collectionView.register(AccountSettingsCell.self, forCellWithReuseIdentifier: AccountCollectionViewController.collectionCell)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: AccountCollectionViewController.logOutButtonCell)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    func navigationBarSetup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-cancel-100"), style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveUser))
    }
}

//MARK: - CollectionView Methods
extension AccountCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AccountCollectionViewController.accountHeaderCell, for: indexPath) as! AccountHeader
        if let imageUrl = self.user?.profileImage, let url = URL(string: imageUrl) {
            headerCell.userImageView.sd_setImage(with: url)
        }
        headerCell.accountController = self
        headerCell.emailLabel.text = self.user?.email
        headerCell.userNameLabel.text = self.user?.name
        self.userImageView = headerCell.userImageView
        self.userImageView?.isUserInteractionEnabled = true
        self.userImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicker)))
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewController.collectionCell, for: indexPath) as! AccountSettingsCell
        cell.backgroundColor = .white
        
        if indexPath.item == 0 {
            cell.titleLabel.text = "Name"
            cell.textField.text = self.user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        } else if indexPath.item == 1 {
            cell.titleLabel.text = "Email"
            cell.textField.text = self.user?.email
            cell.textField.isEnabled = false
        } else {
            let logOutButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountCollectionViewController.logOutButtonCell, for: indexPath)
            self.logOutButton = UIButton(type: .system)
            logOutButton?.translatesAutoresizingMaskIntoConstraints = false
            logOutButton?.setTitle("LogOut", for: .normal)
            logOutButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            logOutButton?.backgroundColor = UIColor(red: 236/255, green: 113/255, blue: 110/255, alpha: 1)
            logOutButton?.tintColor = .white
            logOutButton?.layer.cornerRadius = 4
            logOutButton?.clipsToBounds = true
            logOutButton?.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
            
            logOutButtonCell.addSubview(logOutButton!)
            logOutButton?.centerXAnchor.constraint(equalTo: logOutButtonCell.centerXAnchor).isActive = true
            logOutButton?.centerYAnchor.constraint(equalTo: logOutButtonCell.centerYAnchor).isActive = true
            logOutButton?.widthAnchor.constraint(equalToConstant: 200).isActive = true
            logOutButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return logOutButtonCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 16, height: 94)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func pushToUserPosts() {
        let userPosts = FilteredTableView()
        var posts = [Post]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("posts").child(uid).observe(.value) { [weak self] (snap) in
            guard let self = self else {return}
            guard let snapDict = snap.value as? [String : Any] else {return}
            snapDict.forEach({ (key, value) in
                
                guard let postDictionary = value as? [String : Any] else {return}
                let post = Post(dictionary: postDictionary)
                posts.append(post)
            })
            userPosts.posts = posts
            self.navigationController?.pushViewController(userPosts, animated: true)
        }
    }
}

//MARK: - Objective Methods
extension AccountCollectionViewController {
    
    @objc func handleDismiss() {
        self.user = nil
        dismiss(animated: true)
    }
    
    @objc func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc func handleImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleLogOut() {
        
        do {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Signing out"
            hud.show(in: self.view, animated: true)
            try Auth.auth().signOut()
        } catch {
            self.showProgressHUD(error: error)
        }
        let navRegControleller = UINavigationController(rootViewController: RegistrationController())
        present(navRegControleller, animated: true, completion: nil)
    }
    
    @objc func handleSaveUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let changedValues: [String : Any] = ["fullName" :  user?.name,
                                             "profileImage" : user?.profileImage]
        Database.database().reference().child("users").child(uid).updateChildValues(changedValues)
        
        self.dismiss(animated: true) {
            let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
            homeController.user = self.user
        }
    }
}

//MARK: -  ImagePicker Delegate Methods
extension AccountCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.userImageView?.image = originalImage
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference().child("profileImages").child(fileName)
        
        guard let uploadData = originalImage?.jpegData(compressionQuality: 0.7) else {return}
        
        ref.putData(uploadData, metadata: nil) { [weak self](data, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            
            guard let self = self else {return}
            ref.downloadURL(completion: { (url, err) in
                self.user?.profileImage = url?.absoluteString
            })
        }
        dismiss(animated: true)
    }
    
}
