//
//  ViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class TabBarControllr: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        tabBar.tintColor = .black
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser?.uid == nil {
                let navRegController = UINavigationController(rootViewController: RegistrationController())
                self.present(navRegController, animated: true, completion: nil)
            }
            return
        }
        
        
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = self.navBarController(image: #imageLiteral(resourceName: "home_unselected"), title: "Home", rootViewController: homeController)
        
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
    
    func navBarController(image: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        return navController
    }


}

