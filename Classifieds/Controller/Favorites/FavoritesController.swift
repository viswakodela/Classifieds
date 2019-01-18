//
//  SavedItemsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FavoritesController: UICollectionViewController {
    
    private static let favoritesCellID = "favoritesCellID"
    
    var favoritesArray = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: FavoritesController.favoritesCellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesArray.removeAll()
        fetchFavoritesFromFirebase()
    }

    func fetchFavoritesFromFirebase() {
        var posts = [Post]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Favorites").child(uid).observeSingleEvent(of: .value) { (snap) in
            guard let dictionary = snap.value as? [String : Any] else {return}
            dictionary.forEach({ (key, value) in
                guard let value = value as? Int else {return}
                if value == 1 {
                    let postRef = Database.database().reference().child("posts")
                    postRef.child(key).observeSingleEvent(of: .value, with: { (snap) in
                        guard let postDictionary = snap.value as? [String : Any] else {return}
                        let post = Post(dictionary: postDictionary)
                        self.favoritesArray.append(post)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                }
            })
        }
    }
}


//MARK: - CollectionView Methods
extension FavoritesController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesController.favoritesCellID, for: indexPath) as! HomeControllerCell
        let post = favoritesArray[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 200)
    }
}


