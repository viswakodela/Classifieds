//
//  MapViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/27/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol MapControllerDelegate: class {
    func didTapRow(location: String)
}


class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    
    weak var delegate: MapControllerDelegate?
    var resultsSearchController: UISearchController?
    private let locationSearchCellId = "locationSearchCellId"
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        mv.delegate = self
        return mv
    }()
    
    lazy var tableView: UITableView = {
        let tablevie = UITableView()
        tablevie.translatesAutoresizingMaskIntoConstraints = false
        tablevie.delegate = self
        tablevie.dataSource = self
        return tablevie
    }()
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        checkPermission()
        setupLocationSearchController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: locationSearchCellId)
        tableView.keyboardDismissMode = .onDrag
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 2
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLocationSearchController() {
        resultsSearchController = UISearchController(searchResultsController: resultsSearchController)
        
        guard let resultsController = resultsSearchController else {return}
        resultsController.dimsBackgroundDuringPresentation = false
        resultsController.hidesNavigationBarDuringPresentation = false
        resultsController.searchBar.delegate = self
        
        let searchBar = resultsController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.searchController = resultsController
        definesPresentationContext = true
    }
    
    var matchingItems = [MKMapItem]()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { (resp, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let response = resp else{return}
            let set = Set(response.mapItems)
            let setArray = Array(set)
            for item in setArray {
                self.matchingItems.insert(item, at: 0)
                
                let annotations = MKPointAnnotation()
                annotations.coordinate = item.placemark.coordinate
                
                guard let title = item.name else {return}
                annotations.title = title
                self.mapView.addAnnotation(annotations)
                let center = CLLocationCoordinate2D(latitude: annotations.coordinate.latitude, longitude: annotations.coordinate.longitude)
                let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
                self.mapView.setRegion(region, animated: true)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        guard let text = searchBar.text else {return}
        if text.isEmpty {
            self.matchingItems.removeAll()
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.mapView.annotations.forEach { (annotation) in
            self.mapView.removeAnnotation(annotation)
        }
        self.matchingItems.removeAll()
        tableView.reloadData()
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func centerViewOnUserLocation() {
        
        if let location = locationManager.location {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        } else {
            print("Check the location Services")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            // DO Map Stuff
            mapView.showsUserLocation = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationSearchCellId, for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = "\(parseAddress(selectedItem: selectedItem))"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = HeaderLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        label.text = "Results"
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.matchingItems.isEmpty ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCity = self.matchingItems[indexPath.row].placemark.locality else {return}
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true) {
          self.delegate?.didTapRow(location: selectedCity)
        }
    }
}
