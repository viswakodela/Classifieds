//
//  HomeController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        navigationControllerSetup()
        fetchCurrentUserfromFirebase()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    @objc func handleLogOut() {
        try? Auth.auth().signOut()
        let navRegControleller = UINavigationController(rootViewController: RegistrationController())
        present(navRegControleller, animated: true, completion: nil)
        
    }
    
    fileprivate func navigationControllerSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-edit-property-filled-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNewPost))
    }
    
    @objc func handleNewPost() {
        
        print("Hnadling new Post")
        let newPostController = NewPostController()
        newPostController.user = self.user
        let navController = UINavigationController(rootViewController: newPostController)
        present(navController, animated: true, completion: nil)
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    func fetchCurrentUserfromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let error = err {
                print(error)
                self.showProgressHUD(error: error)
            }
            guard let userDictionary = snapshot?.data() else {return}
            self.user = User(dictionary: userDictionary)
            self.navigationItem.title = self.user?.name
        }
    }
    
    fileprivate func collectionViewSetup() {
        collectionView?.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    //Collection View's Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeader
        return headerCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }
    
}
