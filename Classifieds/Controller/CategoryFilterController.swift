//
//  CategoryFilterController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/2/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class CategoryFilterController: UICollectionViewController {
    
    private let filteredCell = "filteredCell"
    var users = [User]()
    var posts = [Post]()
    var filteredPosts = [Post]()
    var category: CategoryModel! {
        didSet {
            navigationItem.title = category.categoryName
            fetchDataFromFirebase()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: filteredCell)
        collectionView.alwaysBounceVertical = true
    }
    
    func fetchDataFromFirebase() {
//        self.users.forEach { (user) in
//            guard let uid = user.uid else {return}
            guard let category = category.categoryName else {return}
        
            posts.forEach({ (post) in
                if post.categoryName == category {
                    self.filteredPosts.append(post)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            })
//            Firestore.firestore().collection("posts").document(uid).collection("userPosts").whereField("categoryName", isEqualTo: category).getDocuments(completion: { (snap, err) in
//
//                if let error = err {
//                    print(error)
//                }
//
//                guard let snapshot = snap?.documents else {return}
//                snapshot.forEach({ (postsSnap) in
//                    let postsDocument = postsSnap.data()
//                    let posts = Post(dictionary: postsDocument)
//                    self.posts.append(posts)
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                })
//            })
//        }
    }
}

extension CategoryFilterController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filteredCell, for: indexPath) as! HomeControllerCell
        let post = self.filteredPosts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 200)
    }
    
}
