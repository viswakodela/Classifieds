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
    private static let headeCellId = "headeCellId"
    private static let footerId = "footerId"
    private static let customCollectionViewHeader = "customCollectionViewHeader"
    private let refreshControl = UIRefreshControl()
    let locationManager = CLLocationManager()
    
    //MARK: - Variables
    var postsArray = [Post]()
    var previousLocation: CLLocation?
    var user: User?
    var isFinishedPaging = false
    var numberOfItems = 5
    var currentPost: String?
    
    var currentLocation: String? {
        didSet {
            print(currentLocation ?? "")
            self.postsArray.removeAll()
            guard let location = currentLocation else {return}
            self.fetchPostwithPaginating(location: location)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocatinServices()
        collectionViewSetup()
        navigationControllerSetup()
        addNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        addNotificationObservers()
//        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
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
            self?.postsArray = posts
            self?.collectionView.reloadData()
        }
    }
    
    
    func fetchPostwithPaginating(location: String) {
        
        let ref = Database.database().reference().child("cities").child(location)
        
        if currentPost == nil {
            
            ref.queryOrderedByKey().queryLimited(toLast: 5).observe(.value) { (snap) in
                let snapshot = snap.children.allObjects as! [DataSnapshot]
                
                guard let firstKey = snapshot.first else {return}
                
                if snap.childrenCount > 0 {
                    
                    for child in snapshot {
                        
                        let item = child.value as! [String : Any]
                        let post = Post(dictionary: item)
                        
                        let savedPosts = UserDefaults.standard.savedPosts()
                        savedPosts.forEach({ (pst) in
                            if pst.postId == post.postId {
                                post.isFavorited = true
                            }
                        })
                        
                        self.postsArray.append(post)
                    }
                    self.currentPost = firstKey.key
                    self.collectionView.reloadData()
                }
            }
        } else {
            ref.queryOrderedByKey().queryEnding(atValue: currentPost).queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snap) in
                
                let snapshot = snap.children.allObjects as! [DataSnapshot]
                
                guard let firstKey = snapshot.first else {return}
                //                let index = self.postsArray.count
                if snap.children.allObjects.count < 5 {
                    self.isFinishedPaging = true
                }
                if snap.childrenCount > 0 {
                    for child in snap.children.allObjects as! [DataSnapshot] {
                        
                        if child.key != self.currentPost {
                            let item = child.value as! [String : Any]
                            let post = Post(dictionary: item)
                            
                            let savedPosts = UserDefaults.standard.savedPosts()
                            savedPosts.forEach({ (pst) in
                                if pst.postId == post.postId {
                                    post.isFavorited = true
                                }
                            })
                            self.postsArray.append(post)
                        }
                    }
                    self.currentPost = firstKey.key
                    self.collectionView.reloadData()
                }
            }
        }
        
        
//        if currentPost == nil {
//            ref.queryOrderedByKey().queryLimited(toFirst: UInt(numberOfItems)).observe(.value) { (snap) in
//
//                let first = snap.children.allObjects.last as! DataSnapshot
//
//                if snap.childrenCount > 0 {
//
//                    for child in snap.children.allObjects as! [DataSnapshot] {
//
//                            let item = child.value as! [String : Any]
//                            let post = Post(dictionary: item)
//                            self.postsArray.append(post)
//                        }
//                    self.currentPost = first.key
//                    self.collectionView.reloadData()
//                }
//            }
//        } else {
//
//            ref.queryOrderedByKey().queryStarting(atValue: currentPost).queryLimited(toFirst: 5).observeSingleEvent(of: .value) { (snap) in
//
//                guard let first = snap.children.allObjects.last as? DataSnapshot else {return}
////                let index = self.postsArray.count
//                if snap.children.allObjects.count < 5 {
//                    self.isFinishedPaging = true
//                }
//                if snap.childrenCount > 0 {
//                    for child in snap.children.allObjects as! [DataSnapshot] {
//
//                    if child.key != self.currentPost {
//                        let item = child.value as! [String : Any]
//                        let post = Post(dictionary: item)
//                        self.postsArray.append(post)
//
//                        }
//                    }
//                    self.currentPost = first.key
//                    self.collectionView.reloadData()
//                }
//            }
//        }
    }
    
    //MARK: ScrollView method for refetching the data when the maxOffset - contentOffset <= 4
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let contentOffset = scrollView.contentOffset.y
//        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        
//        
//        if maxOffset - contentOffset <= 4 && isFinishedPaging == false {
//            fetchPostwithPaginating(location: self.currentLocation!)
//        }
//    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        
        if maxOffset - contentOffset <= 4 && isFinishedPaging == false {
            fetchPostwithPaginating(location: self.currentLocation!)
        }
    }
    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let contentOffset = scrollView.contentOffset.y
//        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
//
//
//        if maxOffset - contentOffset <= 4 && isFinishedPaging == false {
//            fetchPostwithPaginating(location: self.currentLocation!)
//        }
//    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateNewPost), name: NewPostController.newPostUpdateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnFavoritedPosts), name: FavoritesController.unsaveFavoriteKey, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesFromPriceLabelCell), name: PriceLabelCell.priceLabelUnfavoritesKey, object: nil)
    }
    
    fileprivate func navigationControllerSetup() {
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-gear-100"), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-map-100"), style: .plain, target: self, action: #selector(handleMap))
        
        navigationController?.navigationBar.isTranslucent = false
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleView.text = "Home"
        titleView.textColor = .white
        titleView.font = UIFont.systemFont(ofSize: 22)
        navigationItem.titleView = titleView
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    fileprivate func collectionViewSetup() {
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(HomeHeader.self, forCellWithReuseIdentifier: HomeController.headeCellId)
        
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeController.footerId)
        
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: HomeController.cellId)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader.self, withReuseIdentifier: HomeController.customCollectionViewHeader)
//        collectionView.isPagingEnabled = true
        collectionView.isSpringLoaded = true
    }
    
    deinit {
        print("NewPost Controller Deiniitialized")
        NotificationCenter.default.removeObserver(self)
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
        self.isFinishedPaging = false
        self.currentPost = nil
        let deadLine = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
//            self.fetchPostsFromFirebase()
            self.fetchPostwithPaginating(location: self.currentLocation!)
            self.refreshControl.endRefreshing()
        }
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
    
    @objc func handleSettings() {
        let accountsController = AccountCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: accountsController)
        accountsController.user = self.user
        present(navController, animated: true, completion: nil)
    }
}


// MARK: - CollectionView Delegaete, DataScource and UICOllectionViewDelegateFlowLayout Methods
extension HomeController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //For footer
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeController.footerId, for: indexPath)
            footer.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
            return footer
        }
        
        //For Header
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeController.customCollectionViewHeader, for: indexPath) as! CustomCollectionViewHeader
        headerCell.homeController = self
        if indexPath.section == 0 {
            headerCell.headerLabel.text = "Popular Categories"
            headerCell.locationLabel.text = ""
        } else {
            headerCell.headerLabel.text = "Hot Classifieds"
            if let location = self.currentLocation {
                headerCell.locationLabel.text = location
            }
        }
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: view.frame.width, height: 20) : CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets(top: 0, left: 8, bottom: 4, right: 8) : UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.headeCellId, for: indexPath) as! HomeHeader
            header.homeController = self
            return header
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeController.cellId, for: indexPath) as! HomeControllerCell
        
        if postsArray.count == 0 {
            print("No posts available")
            self.collectionView?.reloadData()
            return cell
        }
        
        //For Paginating
//        if indexPath.item == self.postsArray.count - 1 && isFinishedPaging == false {
//            print("Paginating for Posts")
//            fetchPostwithPaginating(location: self.currentLocation!)
//        }
        
        let selectedPost = postsArray[indexPath.row]
        cell.delegate = self
        cell.post = selectedPost
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 24) / 2
        return indexPath.section == 0 ? CGSize(width: view.frame.width, height: 157) : CGSize(width: width, height: 205)
    }
    
    func showHomeHeaderPush(catergory: CategoryModel) {
        let filteredPostsController = FilterPostsController(collectionViewLayout: UICollectionViewFlowLayout())
        filteredPostsController.category = catergory
        filteredPostsController.posts = self.postsArray
        filteredPostsController.city = self.currentLocation
        navigationController?.pushViewController(filteredPostsController, animated: true)
    }
    
    func handlingLocationChange() {
        let searchLocationFilter = SearchFilterController()
        searchLocationFilter.delegate = self
        let navController = UINavigationController(rootViewController: searchLocationFilter)
        present(navController, animated: true)
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
//            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
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
//            locationManager.pausesLocationUpdatesAutomatically = true
            guard let previouslocation = previousLocation else {return}
            guard  location.distance(from: previouslocation) > 1000 else {return}
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
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

extension HomeController: SearchLocationFilterDelegate {
    
    func cityLocation(of city: String) {
        self.currentLocation = city
        self.postsArray.removeAll()
        self.isFinishedPaging = false
        self.currentPost = nil
        self.fetchPostwithPaginating(location: city)
    }
}
