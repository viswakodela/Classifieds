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


//MARK: -  Protocol
protocol MapControllerDelegate: class {
    func didTapRow(title: String, subtitle: String)
}


class MapViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Cell Identifiers
    private static let locationSearchCellId = "locationSearchCellId"
    let locationManager = CLLocationManager()
    
    //MARk: - Variables
    weak var delegate: MapControllerDelegate?
    var resultsSearchController: UISearchController?
    var searchResults = [MKLocalSearchCompletion]()
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let sC = MKLocalSearchCompleter()
        sC.delegate = self
        return sC
    }()
    
    //MARK: - Layout Properties
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
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        setupLocationSearchController()
        tableViewSetup()
        navigationSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    //MARK:- Methods
    func setupLayout() {
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
    
    func checkPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Check the location Services")
        }
    }
    
    func tableViewSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MapViewController.locationSearchCellId)
        tableView.keyboardDismissMode = .onDrag
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 2
        view.backgroundColor = .white
    }
    
    func navigationSetUp() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
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
        
        guard let searchText = resultsController.searchBar.text else {return}
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.mapView.annotations.forEach { (annotation) in
            self.mapView.removeAnnotation(annotation)
        }
        self.searchResults.removeAll()
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
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
}

//MARK: - Table View Delegate Methods
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapViewController.locationSearchCellId, for: indexPath)
        let selectedItem = searchResults[indexPath.row]
        cell.textLabel?.text = "\(selectedItem.title), \(selectedItem.subtitle)"
//        cell.textLabel?.text = "\(parseAddress(selectedItem: selectedItem))"
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = HeaderLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 47/255, green: 79/255, blue: 79/255, alpha: 1)
        label.text = "Results"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.searchResults.isEmpty ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let searchRequest = MKLocalSearch.Request()
        let searchText = searchResults[indexPath.row]
        searchRequest.naturalLanguageQuery = searchText.title
        searchRequest.region = mapView.region
        
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (resp, err) in
            if let error = err {
                print(error.localizedDescription)
            }
        guard let response = resp?.mapItems else{return}
            
            for item in response {
                let annotations = MKPointAnnotation()
                annotations.coordinate = item.placemark.coordinate
                guard let title = item.name else {return}
                annotations.title = title
                annotations.subtitle = item.placemark.locality
                self.mapView.addAnnotation(annotations)
                let center = CLLocationCoordinate2D(latitude: annotations.coordinate.latitude, longitude: annotations.coordinate.longitude)
                let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000 )
                self.mapView.setRegion(region, animated: true)
                self.dismiss(animated: true, completion: {
                let title = searchText.title
                let subtitle = searchText.subtitle
                self.delegate?.didTapRow(title: title, subtitle: subtitle)
                })
            }
        }
    }
}

//MARK: -  MapView Search Compleater Delegate
extension MapViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.tableView.reloadData()
    }
}

//MARK: -  Search Bar Delegate
extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        } else {
            searchResults.removeAll()
            self.tableView.reloadData()
        }
    }
}
