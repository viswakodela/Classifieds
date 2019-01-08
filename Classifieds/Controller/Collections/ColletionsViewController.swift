//
//  ColletionsViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class ColletionsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let collectionCell = "collectionCell"
    var posts = [Post]() {
        didSet {
            let filterController = FilteredTableView()
            filterController.posts = posts
        }
    }
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        navigationItem.title = "Collections"
        collectionView.register(CollectionsCell.self, forCellWithReuseIdentifier: collectionCell)
        fetchPosts()
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    func fetchPosts() {
        let query = Firestore.firestore().collection("users")
        query.getDocuments { (snap, err) in
            if let error = err {
                self.showProgressHUD(error: error)
                return
            }
            guard let snapshot = snap else {return}
            
            snapshot.documents.forEach({ (snapshot) in
                let userDictionary = snapshot.data()
                let user = User(dictionary: userDictionary)
                self.users.append(user)
                guard let uid = user.uid else {return}
                Firestore.firestore().collection("posts").document(uid).collection("userPosts").getDocuments(completion: { (snap, err) in
                    if let error = err {
                        self.showProgressHUD(error: error)
                    }
                    guard let snapshot = snap else {return}
                    snapshot.documents.forEach({ (snapshot) in
                        let postDictionbary = snapshot.data()
                        let post = Post(dictionary: postDictionbary)
                        //                        print(post.imageUrl1, post.imageUrl2, post.imageUrl3, post.imageUrl4, post.imageUrl5)
                        self.posts.append(post)
                    })
                })
            })
        }
    }
    
    static let shared = ColletionsViewController()
    
    let collectionsArray = [CategoryModel(image: #imageLiteral(resourceName: "phones"), categoryName: "Phones & Tablets"),
                            CategoryModel(image: #imageLiteral(resourceName: "rooms"), categoryName: "Roomes/Beds"),
                            CategoryModel(image: #imageLiteral(resourceName: "bookmark-bowl-business-705675"), categoryName: "Laptops"),
                            CategoryModel(image: #imageLiteral(resourceName: "jobs"), categoryName: "Jobs & Services"),
                            CategoryModel(image: #imageLiteral(resourceName: "furniture"), categoryName: "Furniture"),
                            CategoryModel(image: #imageLiteral(resourceName: "automobile-automotive-car-116675"), categoryName: "Cars")
                            ]
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! CollectionsCell
        cell.categoryModel = collectionsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = collectionsArray[indexPath.item]
        let filterTV = FilteredTableView()
        filterTV.category = category
        navigationController?.pushViewController(filterTV, animated: true)
    }
}
