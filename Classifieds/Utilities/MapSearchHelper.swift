//
//  MapSearchHelper.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/16/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit

class MapSearchHelper {
    
    static func searchText(search: String) -> String? {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = search
        
        var searchCity: String?
        let search = MKLocalSearch(request: searchRequest)
        search.start { (resp, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let response = resp?.mapItems else{return}
            let city = response.first?.placemark.locality
            
            if city != nil {
                searchCity = city
            }
        }
        return searchCity
    }
}
