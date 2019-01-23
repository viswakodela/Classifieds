//
//  PostDetailsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/3/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PostDetailsController: UIViewController {
    
    //MARK: - Cell Identifiers
    private static let normalCellID = "normalCellID"
    private static let collectionViewCellID = "collectionViewCellID"
    private static let titleCellID = "titleCellID"
    private static let sellerDetailsCellID = "sellerDetailsCellID"
    private static let postsDescriptionCellID = "postsDescriptionCellID"
    private static let mapViewCellID = "mapViewCellID"
    private static let otherPostsCellID = "otherPostsCellID"
    private static let priceLabelCellID = "priceLabelCellID"
    
    //MARK: - Variables
    var imagesArray = [String]()
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        tableViewSetUp()
        navigationBarSetup()
        addObservers()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mapview.delegate = nil
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Property Observer
    var post: Post! {
        didSet {
            navigationItem.title = post.title
            if post.imageUrl1 != nil {
                self.imagesArray.append(post.imageUrl1!)
            }
            if post.imageUrl2 != nil {
                self.imagesArray.append(post.imageUrl2!)
            }
            if post.imageUrl3 != nil {
                self.imagesArray.append(post.imageUrl3!)
            }
            if post.imageUrl4 != nil {
                self.imagesArray.append(post.imageUrl4!)
            }
            if post.imageUrl5 != nil {
                self.imagesArray.append(post.imageUrl5!)
            }
        }
    }
    
    //MARK: -  Layout Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 50
        tv.allowsSelection = false
        tv.autoresizesSubviews = true
        return tv
    }()
    
    lazy var mapview: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        return mv
    }()
    
    //MARK: - Methods
    func tableViewSetUp() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: PostDetailsController.normalCellID)
        tableView.register(ImagesCollectionViewCell.self, forCellReuseIdentifier: PostDetailsController.collectionViewCellID)
        tableView.register(TitleForPostDetailCell.self, forCellReuseIdentifier: PostDetailsController.titleCellID)
        tableView.register(SellerDetailsCell.self, forCellReuseIdentifier: PostDetailsController.sellerDetailsCellID)
        tableView.register(PostDescriptionDetailsCell.self, forCellReuseIdentifier: PostDetailsController.postsDescriptionCellID)
        tableView.register(MapViewCell.self, forCellReuseIdentifier: PostDetailsController.mapViewCellID)
        tableView.register(OtherPostsFromSellerCell.self, forCellReuseIdentifier: PostDetailsController.otherPostsCellID)
        tableView.register(PriceLabelCell.self, forCellReuseIdentifier: PostDetailsController.priceLabelCellID)
    }
    
    func navigationBarSetup() {
//        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupLayout() {
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(observeFromFavoritesController), name: FavoritesController.unsaveFavoriteKey, object: nil)
    }
        
    @objc func observeFromFavoritesController(notification: Notification) {
        
        guard let userInfo = notification.userInfo else {return}
        guard let postID = userInfo["postID"] as? String else {return}
        guard let currentPostID = self.post.postId else {return}
        
        if currentPostID == postID {
            post.isFavorited = false
            tableView.reloadData()
        }
    }
    
    deinit {
        print("Deinitialized PostDetailsController")
    }
}

//MARK:- TableViewMethods

extension PostDetailsController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.frame.width
        }  else if indexPath.section == 3 { // SellerInformation Section
            return 70
        } else if indexPath.section == 5  { // MapView Section
            return 194
        } else  if indexPath.section == 6 { //Other Posts Section
            return 140
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let imageCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.collectionViewCellID, for: indexPath) as! ImagesCollectionViewCell
            imageCell.imagesArray = self.imagesArray
            return imageCell
            
        } else if indexPath.section == 1 {
            
            let titleCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.titleCellID, for: indexPath) as! TitleForPostDetailCell
            titleCell.post = self.post
            return titleCell
            
        } else  if indexPath.section == 2 {
            
            let priceCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.priceLabelCellID, for: indexPath) as! PriceLabelCell
            priceCell.post = self.post
            priceCell.delegate = self
            return priceCell
        } else if indexPath.section == 3 {
            
            let sellerCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.sellerDetailsCellID, for: indexPath) as! SellerDetailsCell
            sellerCell.post = self.post
            return sellerCell
            
        } else if indexPath.section == 4 {
            
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.postsDescriptionCellID, for: indexPath) as! PostDescriptionDetailsCell
            descriptionCell.post = self.post
            return descriptionCell
            
        } else if indexPath.section == 5 {
            
            let mapCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.mapViewCellID, for: indexPath) as! MapViewCell
            mapCell.post = post
            mapCell.mapView = self.mapview
            mapview.delegate = self
            return mapCell
            
        } else if indexPath.section == 6 {
            let otherPostsCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.otherPostsCellID, for: indexPath) as! OtherPostsFromSellerCell
            otherPostsCell.post = post
            otherPostsCell.postDetails = self
            return otherPostsCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.normalCellID, for: indexPath)
        let attributedText = NSMutableAttributedString(string: String("  $\(post.price ?? 0)"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor(red: 65/255, green: 165/255, blue: 122/255, alpha: 1)])
        cell.textLabel?.attributedText = attributedText
        return cell
    }
    
    func pushToNewDetailsFromSixthCell(post: Post) {
        let postDetails = PostDetailsController()
        postDetails.post = post
        navigationController?.pushViewController(postDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            tableView.allowsSelection = true
        }
    }
}

//MARK: - MapView cell's Delegate Method
extension PostDetailsController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotations = mapView.annotations
        annotations.forEach { (annot) in
            
            let regionDistance: CLLocationDistance = 1000
            let center = CLLocationCoordinate2D(latitude: annot.coordinate.latitude, longitude: annot.coordinate.longitude)
            let regionSpan = MKCoordinateRegion.init(center: center, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey : regionSpan.center, MKLaunchOptionsMapSpanKey : regionSpan.span] as [String : Any]
            
            let placemark = MKPlacemark(coordinate: annot.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = annot.title ?? "Unknown Location"
            mapItem.openInMaps(launchOptions: options)
        }
    }
}

//MARK: - PriceLabelCellDelegate for Messaging
extension PostDetailsController: PriceLabelDelegate {
    func messageButtonTapped(user: User, post: Post) {
        let newMessage = NewMessageController()
        newMessage.showUserAndPost(user: user, post: post)
        navigationController?.pushViewController(newMessage, animated: true)
    }
}

