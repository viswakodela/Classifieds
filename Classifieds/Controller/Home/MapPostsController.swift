//
//  MapPostsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/4/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPostsController: UIViewController {
    
    //MARK: - Contants
    private let locationManager = CLLocationManager()
    
    //MARK: - Variables
    var posts: [Post] = []
    var bottomViewTopAnchor: NSLayoutConstraint!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        checkLocatinServices()
        displayAnnotationsForPosts()
        navigationItem.title = "Map View"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.delegate = nil
        locationManager.delegate = nil
        self.bottomView.removeFromSuperview()
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Layout Properties
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        mv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        mv.delegate = self
        return mv
    }()
    
    
    //MARK:  BottomView Layout Properties
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = "klsbaiubiuasb"
        return label
    }()
    
    let descriptionView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.numberOfLines = 0
        tv.textColor = .gray
        tv.text = "lihsaoubneursv"
        tv.sizeToFit()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var bottomView: UIView = {
        let bottomview = UIView()
        bottomview.translatesAutoresizingMaskIntoConstraints = false
        bottomview.layer.cornerRadius = 3
        bottomview.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        bottomview.addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: bottomview.topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: bottomview.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: bottomview.trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomview.bottomAnchor).isActive = true
        
        bottomview.addSubview(imageview)
        imageview.topAnchor.constraint(equalTo: bottomview.topAnchor, constant: 8).isActive = true
        imageview.leadingAnchor.constraint(equalTo: bottomview.leadingAnchor, constant: 8).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageview.bottomAnchor.constraint(equalTo: bottomview.bottomAnchor, constant: -8).isActive = true
        
        bottomview.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageview.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: bottomview.trailingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bottomview.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        bottomview.addSubview(descriptionView)
        descriptionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: bottomview.bottomAnchor, constant: -8).isActive = true
        descriptionView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8).isActive = true
        return bottomview
    }()
    
    //MARK:- Methods
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func checkLocatinServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocation()
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    
    func displayAnnotationsForPosts() {
        self.posts.forEach { (post) in
            guard let addres = post.location else {return}
            guard let title = post.title else {return}
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(addres, completionHandler: { [weak self] (placemarks, err) in
                guard let self = self else {return}
                if let error = err {
                    print(error.localizedDescription)
                }
                guard let placemark = placemarks, let firstPlaceMark = placemark.first else {return}
                let annotation = MKPointAnnotation()
                annotation.coordinate = firstPlaceMark.location!.coordinate
                annotation.title = title
                self.mapView.addAnnotation(annotation)
                
                if let location = self.locationManager.location {
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
                    self.mapView.setRegion(region, animated: false)
                }
            })
        }
    }
    
    func setupLayout() {
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(bottomView)
        self.bottomViewTopAnchor = bottomView.topAnchor.constraint(equalTo: view.bottomAnchor)
        bottomViewTopAnchor.isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 164).isActive = true
    }
    
    deinit {
        print("De-initialized from MapPostsController")
    }
}

//MARK: - MApViewDelegate Methods

extension MapPostsController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {return}
        
        let index = self.posts.firstIndex { (post) -> Bool in
            return post.title == annotation.title
        }
        
        guard let indx = index else {return}
        self.titleLabel.text = annotation.title ?? "No title for this Post"
        self.descriptionView.text = posts[indx].description
        self.priceLabel.text = "$\(posts[indx].price ?? 0)"
        
        guard let imageUrl = self.posts[indx].imageUrl1, let url = URL(string: imageUrl) else {return}
        self.imageview.sd_setImage(with: url)
        
        pullUp()
    }
}

//MARK: - CoreLocationManagerDelegate Methods

extension MapPostsController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}

//MARK:- Handling Pan Gesture
extension MapPostsController {
    
    func pullUp() {
        performAnimation(constant: -bottomView.frame.size.height - 20)
    }
    
    func pullDown() {
        performAnimation(constant: 0)
    }
    
    func performAnimation(constant: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bottomViewTopAnchor.constant = constant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleTap() {
        pullDown()
    }
}
