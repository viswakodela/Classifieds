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
    
    private let imageCellId = "imageCellId"
    var isOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: imageCellId)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        vieww.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var posts: Post! {
        didSet {
            if posts.imageUrl1 != nil {
                self.imagesArray.append(posts!.imageUrl1!)
            }
            if posts.imageUrl2 != nil {
                self.imagesArray.append(posts!.imageUrl2!)
            }
            if posts.imageUrl3 != nil {
                self.imagesArray.append(posts!.imageUrl3!)
            }
            if posts.imageUrl4 != nil {
                self.imagesArray.append(posts!.imageUrl4!)
            }
            if posts.imageUrl5 != nil {
                self.imagesArray.append(posts!.imageUrl5!)
            }
            titleLabel.text = posts.title
            descriptionView.text = posts.description
            self.mapViewAnnotationStuff()
            
            guard let uid = posts.uid else {return}
            
            Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
                if let error = err {
                    print(error.localizedDescription)
                }
                guard let snapshot = snap?.data() else {return}
                let user = User(dictionary: snapshot)
                self.sellerNameLabel.text = user.name
            }
            collectionView.reloadData()
        }
    }
    
    func mapViewAnnotationStuff() {
        
        let geoCoder = CLGeocoder()
        guard let location = posts.location else {return}
        geoCoder.geocodeAddressString(location) { (placemarks, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let placemarks = placemarks, let firstLocation = placemarks.first else {return}
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = firstLocation.location!.coordinate
            annotation.title = self.posts.location
            self.mapview.addAnnotation(annotation)
            self.mapview.showAnnotations(self.mapview.annotations, animated: false)
        }
    }
    
    var imagesArray = [String]()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.contentSize.height = 1500
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let vieww: UIView = {
        let iv = UIView()
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = imagesArray.count
        pc.currentPage = 0
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        pc.hidesForSinglePage = true
        return pc
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .green
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.sizeToFit()
        tv.isScrollEnabled = false
        tv.textColor = .gray
        tv.isUserInteractionEnabled = true
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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
        button.setImage(#imageLiteral(resourceName: "icons8-speech-bubble-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.masksToBounds = true
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-forward-arrow-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.masksToBounds = true
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-more-100").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.masksToBounds = true
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-heart-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 0
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.masksToBounds = true
        return button
    }()
    
    let sellerInformationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addBorder(toSide: .Top, withColor: UIColor.gray.cgColor, andThickness: 1)
        view.addBorder(toSide: .Bottom, withColor: UIColor.gray.cgColor, andThickness: 1)
//        view.layer.borderColor = UIColor.gray.cgColor
//        view.layer.borderWidth = 0.2
//        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        return view
    }()
    
    let sellerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "furniture")
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    @objc func handleDismiss() {
        if isOpened {
            dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
    lazy var mapview: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        mv.delegate = self
        return mv
    }()
    
    func setupLayout() {
        
        let attributedText = NSMutableAttributedString(string: "Price", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSMutableAttributedString(string: String("  $\(posts.price ?? 0)"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.gray]))
        priceLabel.attributedText = attributedText

        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1000).isActive = true
        
        scrollView.addSubview(vieww)
        
        vieww.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: vieww.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: vieww.bottomAnchor).isActive = true
        
        vieww.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: vieww.topAnchor, constant: 20).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: vieww.leadingAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        vieww.addSubview(pageControl)
        pageControl.leadingAnchor.constraint(equalTo: vieww.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: vieww.trailingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: vieww.bottomAnchor).isActive = true
        
        scrollView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        scrollView.addSubview(descriptionView)
        descriptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        descriptionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        scrollView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 8).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        sellorInformationView()
        
        if posts.location != nil {
            scrollView.addSubview(locationLabel)
            locationLabel.topAnchor.constraint(equalTo: sellerInformationView.bottomAnchor).isActive = true
            locationLabel.leadingAnchor.constraint(equalTo: sellerInformationView.leadingAnchor, constant: 8).isActive = true
            locationLabel.trailingAnchor.constraint(equalTo: sellerInformationView.trailingAnchor).isActive = true
            locationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            scrollView.addSubview(mapview)
            mapview.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
            mapview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            mapview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            mapview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
    }
    
    func sellorInformationView() {
        
//        sellerInformationView.addBorder(toSide: .Top, withColor: UIColor.gray.cgColor, andThickness: 1)
        
        scrollView.addSubview(sellerInformationView)
        sellerInformationView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
        sellerInformationView.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        sellerInformationView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        sellerInformationView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [messageButton, shareButton, moreButton, favoriteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        sellerInformationView.addSubview(stackView)
        stackView.bottomAnchor.constraint(equalTo: sellerInformationView.bottomAnchor, constant: -8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: sellerInformationView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: sellerInformationView.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        sellerInformationView.addSubview(sellerImageView)
        sellerImageView.topAnchor.constraint(equalTo: sellerInformationView.topAnchor, constant: 8).isActive = true
        sellerImageView.leadingAnchor.constraint(equalTo: sellerInformationView.leadingAnchor, constant: 8).isActive = true
        sellerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sellerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sellerInformationView.addSubview(sellerNameLabel)
        sellerNameLabel.topAnchor.constraint(equalTo: sellerImageView.topAnchor, constant: 13).isActive = true
        sellerNameLabel.leadingAnchor.constraint(equalTo: sellerImageView.trailingAnchor, constant: 8).isActive = true
        sellerNameLabel.trailingAnchor.constraint(equalTo: sellerInformationView.trailingAnchor, constant: -8).isActive = true
        sellerNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
    }
}

extension PostDetailsController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let changeY = -scrollView.contentOffset.y
//        var width = view.frame.width + changeY * 2
//        width = max(width, view.frame.width)
//
//        vieww.frame = CGRect(x: 0, y: 0, width: width, height: width)
        
        let contentOffset = -scrollView.contentOffset.y
        
        if contentOffset > 150 {
            
            if isOpened {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
}

extension PostDetailsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PostImageCell
        let image = imagesArray[indexPath.item]
        cell.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
}

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

