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
import MapKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Static constants
    private static let cellId = "cellId"
    private static let headerId = "headerId"
    private static let customCollectionViewHeader = "customCollectionViewHeader"
    private let refreshControl = UIRefreshControl()
    let locationManager = CLLocationManager()
    
    //MARK: - Variables
    var postsArray = [Post]()
    var previousLocation: CLLocation?
    
    // MARK: - State
    var user: User? {
        didSet {
            self.navigationItem.title = user?.name
        }
    }
    
    var currentLocation: String? {
        didSet {
            print(currentLocation ?? "")
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocatinServices()
        collectionViewSetup()
        addNotificationObservers()
        navigationControllerSetup()
        fetchPostsFromFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        handleRefresh()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - UI and Fetch Methods
    func fetchPostsFromFirebase() {
        
        var posts = [Post]()
        guard let location = self.currentLocation else {return}
        Database.database().reference().child("cities").child(location).observeSingleEvent(of: .value) { [weak self] (snap) in
            guard let postDictionary = snap.value as? [String : Any] else {return}
            postDictionary.forEach({ (key, value) in
                guard let dictionary = value as? [String : Any] else {return}
                let post = Post(dictionary: dictionary)
                
                
                let savedPosts = UserDefaults.standard.savedPosts()
                savedPosts.forEach({ (pst) in
                    if pst.postId == post.postId {
                        post.isFavorited = true
                    }
                })
                posts.append(post)
            })
            DispatchQueue.main.async {
                self?.postsArray = posts
                self?.collectionView.reloadData()
            }
        }
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNewPost), name: NewPostController.newPostUpdateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnFavoritedPosts), name: FavoritesController.unsaveFavoriteKey, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesFromPriceLabelCell), name: PriceLabelCell.priceLabelUnfavoritesKey, object: nil)
    }
    
    fileprivate func navigationControllerSetup() {
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-map-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMap))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    
    fileprivate func collectionViewSetup() {
        
        tabBarController?.tabBar.tintColor = UIColor(red: 64/255, green: 63/255, blue: 63/255, alpha: 1)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = UIColor(red: 64/255, green: 63/255, blue: 63/255, alpha: 1)
        collectionView.refreshControl = refreshControl
//        collectionView?.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeController.headerId)
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: HomeController.cellId)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader.self, withReuseIdentifier: HomeController.customCollectionViewHeader)
    }
}


// MARK: - selector action Methods

extension HomeController {
    
    @objc func handleUpdateNewPost() {
        self.handleRefresh()
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
    
    @objc func handleRefresh() {
        self.postsArray.removeAll()
        fetchPostsFromFirebase()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc func handleMap() {
        let mapPosts = MapPostsController()
        mapPosts.posts = postsArray
        navigationController?.pushViewController(mapPosts, animated: true)
    }
    
    //Unfavoriting from Favorites Controller
    @objc func handleUnFavoritedPosts(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {return}
        guard let postID = userInfo["postID"] as? String else {return}
        
        let index = self.postsArray.firstIndex { (pst) -> Bool in
            return postID == pst.postId
        }
        
        guard let indx = index else {return}
        postsArray[indx].isFavorited = false
        let indexPath = IndexPath(item: indx, section: 1)
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    
    //Unfavoriting form PriceLabelCell
    @objc func handleFavoritesFromPriceLabelCell(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String : Any] else {return}
        guard let postID = userInfo["postID"] as? String else {return}
        
        let index = self.postsArray.firstIndex { (pst) -> Bool in
            return postID == pst.postId
        }
        
        guard let indx = index else {return}
        let indexPath = IndexPath(item: indx, section: 1)
        self.collectionView.reloadItems(at: [indexPath])
    }
}


// MARK: - CollectionView Delegaete, DataScource and UICOllectionViewDelegateFlowLayout Methods
extension HomeController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeController.headerId, for: indexPath) as! HomeHeader
            headerCell.homeController = self
            return headerCell
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeController.customCollectionViewHeader, for: indexPath) as! CustomCollectionViewHeader
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: view.frame.width, height: 150) : CGSize(width: view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.cellId, for: indexPath) as! HomeControllerCell
        
        if postsArray.count == 0 {
            print("No posts available")
            self.collectionView?.reloadData()
            return cell
        }
        
        let selectedPost = postsArray[indexPath.row]
        cell.delegate = self
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
        let filteredCategoryCellController = FilteredTableView()
        filteredCategoryCellController.posts = postsArray
        filteredCategoryCellController.category = catergory
        navigationController?.pushViewController(filteredCategoryCellController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postdetails = PostDetailsController()
        let post = self.postsArray[indexPath.item]
        postdetails.post = post
        navigationController?.pushViewController(postdetails, animated: true)
    }
}

//MARK: - LocationManager Delegate Methods
extension HomeController: CLLocationManagerDelegate {

    func checkLocatinServices() {
        checkPermission()
        setupLocation()
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            checkLocationAuthorization()
        } else {
            print("Check the location Services")
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            // DO Map Stuff
            //            mapView.showsUserLocation = true
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        
        if self.currentLocation == nil {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { [weak self](placemarks, err) in
                guard let self = self else {return}
                self.currentLocation = placemarks?.first?.locality
                self.previousLocation = placemarks?.first?.location
            }
        } else {
            guard let previouslocation = previousLocation else {return}
            guard  location.distance(from: previouslocation) > 1000 else {return}
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}

//MARK: -  HomeControllerCell Delgate Methods
extension HomeController: HomeCellDelegate {
    
    func didTapFavorite(cell: HomeControllerCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let post = self.postsArray[indexPath.item]
        
        var savedPosts = UserDefaults.standard.savedPosts()
        if post.isFavorited == false {
            post.isFavorited = true
            
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-100").withRenderingMode(.alwaysOriginal), for: .normal)
            
            savedPosts.insert(post, at: 0)
            
            guard let data = try? JSONEncoder().encode(savedPosts) else {return}
            UserDefaults.standard.set(data, forKey: UserDefaults.savePostKey)
            
        } else {
            
            post.isFavorited = false
            let index = savedPosts.firstIndex { (pst) -> Bool in
                return post.postId == pst.postId
            }
            guard let indx = index else {return}
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
            savedPosts.remove(at: indx)
            
            guard let data = try? JSONEncoder().encode(savedPosts) else {return}
            UserDefaults.standard.set(data, forKey: UserDefaults.savePostKey)
        }
    }
}
