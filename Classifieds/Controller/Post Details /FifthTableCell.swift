//
//  FifthTableCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit

class FifthTableCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    var post: Post! {
        didSet {
            mapViewAnnotationStuff()
        }
    }
    
    lazy var mapview: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.isZoomEnabled = false
        mv.isScrollEnabled = false
        return mv
    }()
    
    func setupLayout() {
        
        addSubview(mapview)
        mapview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapview.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
