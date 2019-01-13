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
    
    var panGesture: UIPanGestureRecognizer?
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let customCollectionViewHeader = "customCollectionViewHeader"
    let menuWidth: CGFloat = 300
    let threshold: CGFloat = 60
    
    var user: User? {
        didSet {
            self.navigationItem.title = user?.name
        }
    }
    
    let menuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    var postsArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
        navigationControllerSetup()
        fetchPostsFromFirebase()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-map-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMap)), UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))]
        
    }
    
    @objc func handleMap() {
        let mapPosts = MapPostsController()
        postsArray.forEach { (post) in
            mapPosts.posts.append(post)
        }
        navigationController?.pushViewController(mapPosts, animated: true)
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
        return section == 0 ? CGSize(width: view.frame.width, height: 150) : CGSize(width: view.frame.width, height: 30)
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
        filteredCategoryCellController.posts = postsArray
        filteredCategoryCellController.category = catergory
        navigationController?.pushViewController(filteredCategoryCellController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postdetails = PostDetailsController()
        let posts = self.postsArray[indexPath.item]
        postdetails.post = posts
        postdetails.posts = self.postsArray
        navigationController?.pushViewController(postdetails, animated: true)
    } 
}


////MARK:- Sliding Menu Extension
//extension HomeController: UIGestureRecognizerDelegate {
//
//    func setupMenu() {
//
//        view.addSubview(menuView)
//
//        menuView.frame = CGRect(x: -300, y: 0, width: menuWidth, height: view.frame.height)
//
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        collectionView.addGestureRecognizer(panGesture!)
//        panGesture!.delegate = self
////        menuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
////        menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
////        menuView.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
////        menuView.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
//
//    }
//
//    @objc func handlePan(gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: view)
//        var x = translation.x
//        x = max(menuWidth, x)
//
//        menuView.transform = CGAffineTransform(translationX: translation.x, y: 0)
//        if translation.x < 50 {
//            closeMenu()
//        } else {
//            openMenu()
//        }
//    }
//
//    func closeMenu() {
//        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.menuView.frame = CGRect(x: -300, y: 0, width: 300, height: self.view.frame.height)
//            self.menuView.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//    func openMenu() {
//        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.menuView.frame = CGRect(x: 0, y: 0, width: 300, height: self.view.frame.height)
//            self.menuView.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return panGesture!.translation(in: view).x > threshold ? true : false
//    }
//
//
//}
