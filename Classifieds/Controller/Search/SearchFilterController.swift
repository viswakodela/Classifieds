//
//  SearchFilterController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/14/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import Firebase

//MARK: - Protocol
protocol SearchLocationFilterDelegate: class {
    func cityLocation(of city: String)
}

class SearchFilterController: UITableViewController {
    
    //MARK: - TabeleView cell identifier
    private static let searchCell = "searchCell"
    
    //MARK: - Variables
    var searchResults = [MKLocalSearchCompletion]()
    var recentCities = [String]()
    weak var delegate: SearchLocationFilterDelegate?
    var searchLocationController = UISearchController(searchResultsController: nil)
    
    //MARK:- Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController()
        navigationBarSetup()
        tableViewSetup()
        fetchrecentSearchedCity()
    }
    
    //MARk: - Layout Properties
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let sC = MKLocalSearchCompleter()
        sC.delegate = self
        return sC
    }()
    
    //MARK: - Methods
    fileprivate func searchController() {
        navigationItem.searchController = searchLocationController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchLocationController.searchBar.delegate = self
        guard let searchText = searchLocationController.searchBar.text else {return}
        searchCompleter.queryFragment = searchText
    }
    
    fileprivate func tableViewSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SearchFilterController.searchCell)
    }
    
    fileprivate func navigationBarSetup() {
        
        navigationItem.title = "Location Filter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.tintColor = .black
    }
    
    func fetchrecentSearchedCity() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("recent-citysearch").document(uid).getDocument { (snap, err) in
            guard let recentCity = snap?.data() else {return}
            let city = recentCity["searchedCity"] as? String
            self.recentCities.append(city ?? "")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Selector objective functions
extension SearchFilterController {
    @objc func handleCancel() {
        dismiss(animated: true)
    }
}

//MARK:- MKLocalSearchCompleter Delegate Method
extension SearchFilterController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.tableView.reloadData()
    }
}

//MARK:-  SearDelegate Methods
extension SearchFilterController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.searchResults.removeAll()
            self.tableView.reloadData()
        } else {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
        self.tableView.reloadData()
    }
}


//MARK:- TableView Methods
extension SearchFilterController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? recentCities.count : searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = HeaderLabel()
        label.text = "Recently Searched"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = .white
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchFilterController.searchCell, for: indexPath)
            cell.textLabel?.text = searchResults[indexPath.row].title
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.numberOfLines = 0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchFilterController.searchCell, for: indexPath)
            cell.textLabel?.text = self.recentCities[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var location: String
        
        if indexPath.section == 0 {
            location = recentCities[indexPath.row]
        } else {
            location = searchResults[indexPath.row].title
        }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, err) in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let mapItems = response?.mapItems else {return}
            
            guard let city = mapItems.first?.placemark.locality else {return}
            
            // Saving recent Searches into FireBase
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let recentSearchData = ["searchedCity" : city]
            
            Firestore.firestore().collection("recent-citysearch").document(uid).setData(recentSearchData)
            
            self.delegate?.cityLocation(of: city)
            self.dismiss(animated: true)
        }
    }
}
