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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupLayout()
    }
    
    var posts: [Post] = []
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        mv.delegate = self
        return mv
    }()
    
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
                    self.mapView.setRegion(region, animated: true)
                }
//                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            })
        }
    }
    
    func setupLayout() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension MapPostsController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let title = view.annotation?.title else {return}
        
        guard let post = self.posts.first(where: {$0.title == title}) else {return}
        
        
    }
    
}

extension MapPostsController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
    
}
