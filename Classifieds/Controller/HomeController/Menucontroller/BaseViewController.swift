//
//  MenuController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/7/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class BaseScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupViews()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        darkCoverView.addGestureRecognizer(tapGesture)
        fetchCurrentUserfromFirebase()
    }
    
    func fetchCurrentUserfromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { [unowned self] (snapshot, err) in
            if let error = err {
                print(error)
            }
            guard let userDictionary = snapshot?.data() else {return}
            let user = User(dictionary: userDictionary)
            self.homeController.user = user
            self.menuController.user = user
            
        }
    }

    
    let menuController = MenuViewController()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isMenuOpened ? .lightContent : .default
    }
    
    @objc func handleTap() {
        closeMenu()
    }
    
    var redViewLeadingAnchor: NSLayoutConstraint!
    var redViewTrailingAnchor: NSLayoutConstraint!
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var x = translation.x
        
        x = isMenuOpened ? x + menuWidth : x
        x = min(menuWidth, x)
        x = max(0, x) // this piece of code is for the negative direction
        
        self.redViewLeadingAnchor.constant = x
        self.redViewTrailingAnchor.constant = x
        darkCoverView.alpha = x / menuWidth
        
        if gesture.state == .ended {
            gestureEnded(gesture: gesture)
        }
    }
    
    let darkCoverView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        return view
    }()
    
    fileprivate func gestureEnded(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        if translation.x < 50 {
            closeMenu()
        } else {
            openMenu()
        }
    }
    
    func openMenu() {
        redViewLeadingAnchor.constant = menuWidth
        redViewTrailingAnchor.constant = menuWidth
        isMenuOpened = true
        performAnimation()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func closeMenu() {
        redViewLeadingAnchor.constant = 0
        redViewTrailingAnchor.constant = 0
        isMenuOpened = false
        performAnimation()
        setNeedsStatusBarAppearanceUpdate()
    }
    
//    func didSelectMenuItems(indexPath: IndexPath) {
//
//        setupClearMemoryLeaks()
//
//        switch indexPath.row {
//        case 0:
//            let vc = UINavigationController(rootViewController: HomeController())
//            redView.addSubview(vc.view)
//            addChild(vc)
//            rightViewController = vc
//
//        case 1:
//            let collections = ColletionsViewController(collectionViewLayout: UICollectionViewFlowLayout())
//            let navigationController = UINavigationController(rootViewController: collections)
//            redView.addSubview(navigationController.view)
//            addChild(navigationController)
//            rightViewController = navigationController
//        case 2:
//            let searchController = SearchController()
//            self.redView.addSubview(searchController.view)
//            addChild(searchController)
//            rightViewController = searchController
//        default:
//            let tabBarController = UITabBarController()
//            let momentsController = UIViewController()
//            momentsController.view.backgroundColor = .orange
//            let navController = UINavigationController(rootViewController: momentsController)
//            momentsController.navigationItem.title = "Moments"
//            tabBarController.viewControllers = [navController]
//            navController.tabBarItem.title = "Moments"
//
//            redView.addSubview(tabBarController.view)
//            addChild(tabBarController)
//            rightViewController = tabBarController
//        }
//
//        redView.bringSubviewToFront(darkCoverView)
//        closeMenu()
//    }
    
    func performAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.darkCoverView.alpha = self.isMenuOpened ? 1 : 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    let redView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let blueView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    let menuWidth: CGFloat = 300
    var isMenuOpened = false
    let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
    
    func setupViews() {
        
        tabBarItem.image = #imageLiteral(resourceName: "home_selected")
        tabBarItem.title = "Home"
        self.view.addSubview(redView)
        redView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.redViewLeadingAnchor = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        redViewLeadingAnchor.isActive = true
        self.redViewTrailingAnchor = redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        redViewTrailingAnchor.isActive = true
        redView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(blueView)
        blueView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blueView.trailingAnchor.constraint(equalTo: redView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        blueView.widthAnchor.constraint(equalToConstant: menuWidth).isActive = true
        blueView.bottomAnchor.constraint(equalTo: redView.bottomAnchor).isActive = true
        
        setupViewControllers()
    }
    
    
    
//    func setupClearMemoryLeaks() {
//        navHomeController.view.removeFromSuperview()
//        navHomeController.removeFromParent()
//    }
//
    
    func setupViewControllers() {
        
        //        let homeControlelr = HomeController()
        let navHomeController = UINavigationController(rootViewController: self.homeController)
        
        guard let homeView = navHomeController.view else {return}
        guard let menuView = menuController.view else {return}
        homeView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        redView.addSubview(homeView)
        homeView.topAnchor.constraint(equalTo: redView.topAnchor).isActive = true
        homeView.leadingAnchor.constraint(equalTo: redView.leadingAnchor).isActive = true
        homeView.trailingAnchor.constraint(equalTo: redView.trailingAnchor).isActive = true
        homeView.bottomAnchor.constraint(equalTo: redView.bottomAnchor).isActive = true
        
        redView.addSubview(darkCoverView)
        darkCoverView.topAnchor.constraint(equalTo: redView.topAnchor).isActive = true
        darkCoverView.leadingAnchor.constraint(equalTo: redView.leadingAnchor).isActive = true
        darkCoverView.trailingAnchor.constraint(equalTo: redView.trailingAnchor).isActive = true
        darkCoverView.bottomAnchor.constraint(equalTo: redView.bottomAnchor).isActive = true
        
        blueView.addSubview(menuView)
        menuView.topAnchor.constraint(equalTo: blueView.topAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor).isActive = true
        
        addChild(navHomeController)
        addChild(menuController)
        
    }
    
}
