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
    
    private let normalCell = "normalCell"
    private let tableViewCell1 = "tableViewCell1"
    private let tableViewCell2 = "tableViewCell2"
    private let tableViewCell3 = "tableViewCell3"
    private let tableViewCell4 = "tableViewCell4"
    private let tableViewCell5 = "tableViewCell5"
    private let tableViewCell6 = "tableViewCell6"
    var otherPostsFromSameUser = [Post]()
    
    var posts = [Post]() {
        didSet {
            posts.forEach { (post) in
                
                if post.uid == self.post.uid {
                    if post.title == self.post.title {
                        return
                    } else {
                        self.otherPostsFromSameUser.append(post)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .white
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.separatorStyle = .none
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: normalCell)
        tableView.register(FirstTableViewCell.self, forCellReuseIdentifier: tableViewCell1)
        tableView.register(SecondTableViewCell.self, forCellReuseIdentifier: tableViewCell2)
        tableView.register(ThirdTableViewCell.self, forCellReuseIdentifier: tableViewCell3)
        tableView.register(FourthTableCell.self, forCellReuseIdentifier: tableViewCell4)
        tableView.register(FifthTableCell.self, forCellReuseIdentifier: tableViewCell5)
        tableView.register(SixthTableCell.self, forCellReuseIdentifier: tableViewCell6)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var post: Post! {
        didSet {
            navigationItem.title = post.title
            if post.imageUrl1 != nil {
                self.imagesArray.append(post!.imageUrl1!)
            }
            if post.imageUrl2 != nil {
                self.imagesArray.append(post!.imageUrl2!)
            }
            if post.imageUrl3 != nil {
                self.imagesArray.append(post!.imageUrl3!)
            }
            if post.imageUrl4 != nil {
                self.imagesArray.append(post!.imageUrl4!)
            }
            if post.imageUrl5 != nil {
                self.imagesArray.append(post!.imageUrl5!)
            }
//            titleLabel.text = post.title
//            descriptionView.text = post.description
            self.mapViewAnnotationStuff()
            
            guard let uid = post.uid else {return}
            
//            Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
//                if let error = err {
//                    print(error.localizedDescription)
//                }
//                guard let snapshot = snap?.data() else {return}
//                let user = User(dictionary: snapshot)
//                self.sellerNameLabel.text = user.name
//                
//                if user.profileImage == nil {
//                    self.sellerImageView.image = #imageLiteral(resourceName: "icons8-account-filled-100")
//                } else {
//                    guard let image = user.profileImage, let url = URL(string: image) else {return}
//                    self.sellerImageView.sd_setImage(with: url)
//                }
//            }
//            collectionView.reloadData()
        }
    }
    
    func mapViewAnnotationStuff() {
        
        let geoCoder = CLGeocoder()
        guard let location = post.location else {return}
        geoCoder.geocodeAddressString(location) { (placemarks, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let placemarks = placemarks, let firstLocation = placemarks.first else {return}
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = firstLocation.location!.coordinate
            annotation.title = self.post.location
            self.mapview.addAnnotation(annotation)
            self.mapview.showAnnotations(self.mapview.annotations, animated: false)
        }
    }
    
    var imagesArray = [String]()
    
    let vieww: UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .green
        return iv
    }()
    
//    lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.clipsToBounds = true
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.isPagingEnabled = true
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.alwaysBounceHorizontal = true
//        return collectionView
//    }()
    
    let blackBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .green
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Location"
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-cancel-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-speech-bubble-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMessage() {
        let newMessage = NewMessageController()
        newMessage.post = self.post
        newMessage.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(newMessage, animated: true)
    }
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-share-rounded-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-more-details-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-star-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    let sellerInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    @objc func handleDismiss() {
//        if isOpened {
//            dismiss(animated: true, completion: nil)
//        }
//        navigationController?.popViewController(animated: true)
    }
    
    lazy var mapview: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        mv.delegate = self
        return mv
    }()
    
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
    
    func setupLayout() {
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
//    lazy var header: UIView = {
//        let headerView = UIView()
////        headerView.translatesAutoresizingMaskIntoConstraints = false
//
//        headerView.addSubview(vieww)
//        vieww.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
//        vieww.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
//        vieww.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
//        vieww.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//
//        vieww.addSubview(collectionView)
//        collectionView.topAnchor.constraint(equalTo: vieww.topAnchor).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: vieww.leadingAnchor).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: vieww.trailingAnchor).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: vieww.bottomAnchor).isActive = true
//
//        vieww.addSubview(pageControl)
//        pageControl.leadingAnchor.constraint(equalTo: vieww.leadingAnchor).isActive = true
//        pageControl.trailingAnchor.constraint(equalTo: vieww.trailingAnchor).isActive = true
//        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        pageControl.bottomAnchor.constraint(equalTo: vieww.bottomAnchor, constant: -10).isActive = true
//
//        headerView.addSubview(titleLabel)
//        titleLabel.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: 8).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
//        titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8).isActive = true
//        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
//
//        headerView.addSubview(descriptionView)
//        descriptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
//        descriptionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
//        descriptionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8).isActive = true
//        descriptionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
//
//        headerView.addSubview(priceLabel)
//        priceLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 8).isActive = true
//        priceLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor).isActive = true
//        priceLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor).isActive = true
//        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        let attributedText = NSMutableAttributedString(string: "Price", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
//        attributedText.append(NSMutableAttributedString(string: String("  $\(post.price ?? 0)"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.gray]))
//        priceLabel.attributedText = attributedText
//
//        headerView.addSubview(sellerInformationView)
//        sellerInformationView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4).isActive = true
//        sellerInformationView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
//        sellerInformationView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
//        sellerInformationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        sellerInformationView.addSubview(sellerImageView)
//        sellerImageView.topAnchor.constraint(equalTo: sellerInformationView.topAnchor).isActive = true
//        sellerImageView.leadingAnchor.constraint(equalTo: sellerInformationView.leadingAnchor).isActive = true
//        sellerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        sellerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        sellerInformationView.addSubview(sellerNameLabel)
//        sellerNameLabel.topAnchor.constraint(equalTo: sellerInformationView.topAnchor).isActive = true
//        sellerNameLabel.leadingAnchor.constraint(equalTo: sellerImageView.trailingAnchor, constant: 4).isActive = true
//        sellerNameLabel.trailingAnchor.constraint(equalTo: sellerInformationView.trailingAnchor).isActive = true
//        sellerNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
//
//        let stackView = UIStackView(arrangedSubviews: [messageButton, shareButton, moreButton, favoriteButton])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 20
//        stackView.backgroundColor = .blue
//
//        sellerInformationView.addSubview(stackView)
//        stackView.topAnchor.constraint(equalTo: sellerImageView.bottomAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: sellerInformationView.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: sellerInformationView.trailingAnchor).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        headerView.addSubview(mapview)
//        mapview.topAnchor.constraint(equalTo: sellerInformationView.bottomAnchor, constant: 4).isActive = true
//        mapview.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
//        mapview.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
//        mapview.heightAnchor.constraint(equalToConstant: 150).isActive = true
//
//
//        return headerView
//    }()
}

//extension PostDetailsController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
////        let changeY = -scrollView.contentOffset.y
////        var width = view.frame.width + changeY * 2
////        width = max(width, view.frame.width)
////
////        vieww.frame = CGRect(x: 0, y: 0, width: width, height: width)
//
//        let contentOffset = -scrollView.contentOffset.y
//
////        if contentOffset > 150 {
////            if isOpened {
////                dismiss(animated: true, completion: nil)
////            } else {
////                navigationController?.popViewController(animated: true)
////            }
////        }
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let x = targetContentOffset.pointee.x
//        pageControl.currentPage = Int(x / view.frame.width)
//    }
//}



//
//extension PostDetailsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imagesArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PostImageCell
//        let image = imagesArray[indexPath.item]
//        cell.image = image
//        cell.imageview.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch)))
//        return cell
//    }
//
//    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
//
//        if gesture.state == .changed {
//            gesture.view?.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
//        }
//
//        if gesture.state == .ended {
//            UIView.animate(withDuration: 0.5) {
//                gesture.view?.transform = .identity
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: view.frame.width)
//    }
//}

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
        } else if indexPath.section == 5 {
            return 110
        } else  if indexPath.section == 6 {
            return 140
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let firstTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell1, for: indexPath) as! FirstTableViewCell
            firstTableViewCell.imagesArray = self.imagesArray
            return firstTableViewCell
            
        } else if indexPath.section == 1 {
            
            let secondTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell2, for: indexPath) as! SecondTableViewCell
            secondTableViewCell.post = self.post
            return secondTableViewCell
            
        } else if indexPath.section == 3 {
            
            let thirdTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell3, for: indexPath) as! ThirdTableViewCell
            thirdTableViewCell.post = self.post
            return thirdTableViewCell
            
        } else if indexPath.section == 4 {
            
            let fourthCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell4, for: indexPath) as! FourthTableCell
            fourthCell.post = self.post
            return fourthCell
            
        } else if indexPath.section == 5 {
            
            let fifthCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell5, for: indexPath) as! FifthTableCell
            fifthCell.mapview.delegate = self
            fifthCell.post = post
            return fifthCell
            
        } else if indexPath.section == 6 {
            let sixthCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell6, for: indexPath) as! SixthTableCell
            sixthCell.post = post
            sixthCell.postDetails = self
            return sixthCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: normalCell, for: indexPath)
        let attributedText = NSMutableAttributedString(string: "Price", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSMutableAttributedString(string: String("  $\(post.price ?? 0)"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.gray]))
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

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 0 : otherPostsFromSameUser.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 1000
//        } else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 116
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath) as! FilterTableViewCell
//        let post = otherPostsFromSameUser[indexPath.row]
//        cell.post = post
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = otherPostsFromSameUser[indexPath.row]
//        let navPush = PostDetailsController()
//        navPush.post = post
//        navPush.posts = self.posts
//        navigationController?.pushViewController(navPush, animated: true)
//    }
}

