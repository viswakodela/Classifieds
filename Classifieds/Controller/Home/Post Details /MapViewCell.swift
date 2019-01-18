//
//  FifthTableCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit

class MapViewCell: UITableViewCell {
    
    weak var postDetailController: PostDetailsController?
    
    //MARK: - Cell Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    //MARK: - Property Observer
    var post: Post! {
        didSet {
            mapViewAnnotationStuff()
        }
    }
    
    //MARK: - Layout Properties
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var mapview: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        return mv
    }()
    
    //MARK: - Methods
    func setupLayout() {
        
        addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        addSubview(mapview)
        mapview.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4).isActive = true
        mapview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    func mapViewAnnotationStuff() {
        
        let geoCoder = CLGeocoder()
        guard let location = post.location else {return}
        geoCoder.geocodeAddressString(location) { [weak self] (placemarks, err) in
            guard let self = self else {return}
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
    
    func clearMapViewMemoryLeak() {
        switch mapview.mapType {
        case .hybrid :
            self.mapview.mapType = .standard
            break
        case .standard:
            self.mapview.mapType = .hybrid
        default:
            break
        }
    }
    
    deinit {
        print("MapCell Deinitialized")
        clearMapViewMemoryLeak()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
