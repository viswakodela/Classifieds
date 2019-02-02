//
//  ViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import MapKit

class TabBarControllr: UITabBarController {
    
    //MARK: - Constants
    let locationManager = CLLocationManager()
    
    //MARK: - Variables
    var homeController: HomeController?
    var currentLocation: String?
    
    //MARK: -  Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        viewControllersSetup()
        fetchCurrentUserfromFirebase()
        tabBarSetup()
        
        
    }
    
    //MARK: - Methods
    func tabBarSetup() {
        
        tabBar.tintColor = .black
        tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: -4, bottom: 4, right: 4)
    }
    
    func viewControllersSetup() {
        DispatchQueue.main.async {
            if Auth.auth().currentUser?.uid == nil {
                let navRegController = UINavigationController(rootViewController: RegistrationController())
                self.present(navRegController, animated: true, completion: nil)
            }
            return
        }
        
        self.homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        guard let home = self.homeController else {return}
        let homeNavController = self.navBarController(image: #imageLiteral(resourceName: "home-1"), title: "Home", rootViewController: home)
        
        let searchController = SearchController()
        let searchNavController = self.navBarController(image: #imageLiteral(resourceName: "search_unselected"), title: "Search", rootViewController: searchController)
        
        let newPostController = NewPostController()
        let newPoatNavController = self.navBarController(image: #imageLiteral(resourceName: "icons8-add-90"), title: "Post", rootViewController: newPostController)
        
        let saveItemController = FavoritesController(collectionViewLayout: UICollectionViewFlowLayout())
        let favoriteNavController =  self.navBarController(image: #imageLiteral(resourceName: "icons8-star-filled-100"), title: "Save", rootViewController: saveItemController)
        
        let messageController = MessagesTableController()
        let messagesNavController = self.navBarController(image: #imageLiteral(resourceName: "icons8-chat-bubble-100"), title: "Messages", rootViewController: messageController)
        
        
        viewControllers = [homeNavController,
                           searchNavController,
                           newPoatNavController,
                           favoriteNavController,
                           messagesNavController
        ]
    }
    
    func fetchCurrentUserfromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        
        Database.database().reference().child("users").child(uid).observe(.value) { [weak self] (snap) in
            guard let snapDict = snap.value as? [String : Any] else {return}
            let user = User(dictionary: snapDict)
            self?.homeController?.user = user
        }
    }
    
    func navBarController(image: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        return navController
    }
}

//MARK: - TabBarDelegate Method
extension TabBarControllr: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            let newPost = NewPostController()
            let newPostNav = UINavigationController(rootViewController: newPost)
            present(newPostNav, animated: true, completion: nil)
            return false
        }
        return true
    }
}



