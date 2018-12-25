//
//  ViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        
        tabBar.tintColor = .blue
        
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = self.tabBarController(image: #imageLiteral(resourceName: "home_unselected"), title: "Home", rootViewController: homeController)
        
        let collections = ColletionsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let collectionsNavController = self.tabBarController(image: #imageLiteral(resourceName: "collection"), title: "Collections", rootViewController: collections)
        
        let saveItemController = SavedItemsController(collectionViewLayout: UICollectionViewFlowLayout())
        let savedNavController =  self.tabBarController(image: #imageLiteral(resourceName: "heart"), title: "Save", rootViewController: saveItemController)
        
        let searchController = SearchController()
        let searchNavController = self.tabBarController(image: #imageLiteral(resourceName: "search_unselected"), title: "Search", rootViewController: searchController)
        
        
        
        viewControllers = [homeNavController,
                           collectionsNavController,
                           savedNavController,
                            searchNavController
                        ]
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
    }
    
    func tabBarController(image: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> UIViewController {
        let navController = rootViewController
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        return navController
    }


}

