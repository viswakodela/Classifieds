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

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NewPostRefreshControlDelegate {
    
    
    func didFinishPosting() {
        self.handleRefresh()
    }
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let customCollectionViewHeader = "customCollectionViewHeader"
    
    var user: User? {
        didSet {
            self.navigationItem.title = user?.name
        }
    }
    
    var postsArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        navigationControllerSetup()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        fetchPostsFromFirebase()
    }
    
    var users = [User]()
    func fetchPostsFromFirebase() {
        
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
                        self.postsArray.append(post)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                })
            })
        }
    }
    
    @objc func handleLogOut() {
        
        do {
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Signing out"
            hud.show(in: self.view)
            try Auth.auth().signOut()
        } catch {
            self.showProgressHUD(error: error)
        }
        let navRegControleller = UINavigationController(rootViewController: RegistrationController())
        present(navRegControleller, animated: true, completion: nil)
        
    }
    
    fileprivate func navigationControllerSetup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-edit-property-filled-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNewPost))
    }
    
    @objc func handleNewPost() {
        
        print("Hnadling new Post")
        let newPostController = NewPostController()
        newPostController.delegate = self
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
    
    let refreshControl = UIRefreshControl()
    
    fileprivate func collectionViewSetup() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView?.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader.self, withReuseIdentifier: customCollectionViewHeader)
    }
    
    @objc func handleRefresh() {
        self.postsArray.removeAll()
        self.users.removeAll()
        fetchPostsFromFirebase()
        collectionView.refreshControl?.endRefreshing()
    }
}

extension HomeController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeader
            headerCell.homeController = self
            return headerCell
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: customCollectionViewHeader, for: indexPath) as! CustomCollectionViewHeader
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: view.frame.width, height: 200) : CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeControllerCell
        
        if postsArray.count == 0 {
            print("No posts available")
            self.collectionView?.reloadData()
            return cell
        }
        
        let selectedPost = postsArray[indexPath.row]
        cell.post = selectedPost
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: 200)
    }
    
    func showHomeHeaderPush(catergory: CategoryModel) {
        let filteredCategoryCellController = CategoryFilterController(collectionViewLayout: UICollectionViewFlowLayout())
        filteredCategoryCellController.users = users
        filteredCategoryCellController.posts = postsArray
        filteredCategoryCellController.category = catergory
        navigationController?.pushViewController(filteredCategoryCellController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postdetails = PostDetailsController()
        let posts = self.postsArray[indexPath.item]
        postdetails.posts = posts
        navigationController?.pushViewController(postdetails, animated: true)
    }
    
}
