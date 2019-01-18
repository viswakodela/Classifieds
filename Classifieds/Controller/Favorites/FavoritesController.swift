//
//  SavedItemsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import Lottie

private let reuseIdentifier = "Cell"

class FavoritesController: UICollectionViewController {
    
    //MARK: - Cell Identifier
    private static let favoritesCellID = "favoritesCellID"
    
    //MARK: - Notification Name
    static let unsaveFavoriteKey = Notification.Name("unsaveFavoriteKey")
    
    //MARK: - Variables
    var favoritesArray = [Post]()
    var favoriteAnimationView: LOTAnimationView?

    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoritesArray.removeAll()
        fetchFavoritesFromUserDefaults()
    }
    
    //MARK: - Methods
    func collectionViewSetUp() {
        collectionView.backgroundColor = .white
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: FavoritesController.favoritesCellID)
        collectionView.alwaysBounceVertical = true
    }
    
    func fetchFavoritesFromUserDefaults() {
        self.favoritesArray = UserDefaults.standard.savedPosts()
        self.collectionView.reloadData()
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
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = favoritesArray[indexPath.item]
        let postDetails = PostDetailsController()
        postDetails.post = post
        navigationController?.pushViewController(postDetails, animated: true)
    }
}


//MARK: - HomeCellDelegate Method for favorite button tapping
extension FavoritesController: HomeCellDelegate {
    
    func didTapFavorite(cell: HomeControllerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let post = favoritesArray[indexPath.item]
        
        if post.isFavorited == true {
            post.isFavorited = false
            var savedPosts = UserDefaults.standard.savedPosts()
            let index = savedPosts.firstIndex { (pst) -> Bool in
                return post.postId == pst.postId
            }
            
            guard let indx = index else {return}
            savedPosts.remove(at: indx)
            guard let data = try? JSONEncoder().encode(savedPosts) else {return}
            UserDefaults.standard.set(data, forKey: UserDefaults.savePostKey)
            guard let postID = post.postId else {return}
            NotificationCenter.default.post(name: FavoritesController.unsaveFavoriteKey, object: nil, userInfo: ["postID" : postID])
        }
        self.fetchFavoritesFromUserDefaults()
    }
}


