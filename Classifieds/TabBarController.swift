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

class TabBarControllr: UITabBarController {

    var user: User?
    var homeController: HomeController?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUserfromFirebase()
        // Do any additional setup after loading the view, typically from a nib.
        tabBar.tintColor = .black
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser?.uid == nil {
                let navRegController = UINavigationController(rootViewController: RegistrationController())
                self.present(navRegController, animated: true, completion: nil)
            }
            return
        }
        
        self.homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        guard let home = self.homeController else {return}
        let homeNavController = self.navBarController(image: #imageLiteral(resourceName: "home_unselected"), title: "Home", rootViewController: home)
        
        let collections = ColletionsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let collectionsNavController = self.navBarController(image: #imageLiteral(resourceName: "collection"), title: "Collections", rootViewController: collections)
        
        let saveItemController = SavedItemsController(collectionViewLayout: UICollectionViewFlowLayout())
        let savedNavController =  self.navBarController(image: #imageLiteral(resourceName: "heart"), title: "Save", rootViewController: saveItemController)
        
        let searchController = SearchController()
        let searchNavController = self.navBarController(image: #imageLiteral(resourceName: "search_unselected"), title: "Search", rootViewController: searchController)
        
        
        
        viewControllers = [homeNavController,
                           collectionsNavController,
                           savedNavController,
                            searchNavController
                        ]
        
        tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: -4, bottom: 4, right: 4)
        
    }
    
    func fetchCurrentUserfromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { [unowned self] (snapshot, err) in
            if let error = err {
                print(error)
            }
            guard let userDictionary = snapshot?.data() else {return}
            self.user = User(dictionary: userDictionary)
            self.homeController?.user = self.user
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

