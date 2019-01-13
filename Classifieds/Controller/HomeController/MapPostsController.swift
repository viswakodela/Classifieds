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
    
    var locationManager = CLLocationManager()
    
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
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    var posts: [Post] = []
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        mv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        mv.delegate = self
        return mv
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var bottomViewTopAnchor: NSLayoutConstraint!
    
    func displayAnnotationsForPosts() {
        self.posts.forEach { (post) in
            guard let addres = post.location else {return}
            guard let title = post.title else {return}
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(addres, completionHandler: { (placemarks, err) in
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
        self.bottomViewTopAnchor = bottomView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8)
        bottomViewTopAnchor.isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
        
        setupViewControllers()
    }
    
    var postView: UIView!
    let bottomController = BottomUpController()
    func setupViewControllers() {
        
        self.postView = bottomController.view
        postView.translatesAutoresizingMaskIntoConstraints = false
        postView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePullGesture(gesture:))))
        postView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        
        bottomView.addSubview(postView)
        postView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8).isActive = true
        postView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        postView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        postView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        
        addChild(bottomController)
    }
}

extension MapPostsController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let title = view.annotation?.title else {return}
        
        guard let post = self.posts.first(where: {$0.title == title}) else {return}
        bottomController.post = post
        bottomController.tableView.reloadData()
        pullUp()
    }
}

extension MapPostsController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}

//MARK:- Handling Pan Gesture
extension MapPostsController {
    
    @objc func handlePullGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if translation.y < -80 {
            pullUp()
        } else {
            pullDown()
        }
    }
    
    func pullUp() {
        self.bottomViewTopAnchor.constant = -240
        performAnimation()
    }
    
    func pullDown() {
        self.bottomViewTopAnchor.constant = 0
        performAnimation()
    }
    
    func performAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleTap() {
        pullDown()
    }
    
}
