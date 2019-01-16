//
//  SearchController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class SearchController: UITableViewController {
    
    //MARK: - TableView Cell Identifiers
    private static let searchCellID = "searchCellID"
    
    //MARK: - variables
    var posts = [Post]()
    var filteredposts = [Post]()
    var searchController = UISearchController(searchResultsController: nil)
    var refreshControle = UIRefreshControl()
    var cityFiler: String?
    
    //MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostsfromFirebase()
        tableViewSetup()
        navigationBarSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if cityFiler != nil {
            posts.removeAll()
            fetchPostsfromFirebase()
        }
    }
    
    //MARK: - Layout Properties
    
    let datePriceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Date", "Price"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.isUserInteractionEnabled = true
        sc.layer.cornerRadius = 5
        sc.clipsToBounds = true
        sc.backgroundColor = .white
        sc.tintColor = .black
        sc.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
        return sc
    }()
    
    lazy var headerView: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = .white
        header.addSubview(datePriceSegmentedControl)
        datePriceSegmentedControl.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8).isActive = true
        datePriceSegmentedControl.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8).isActive = true
        datePriceSegmentedControl.topAnchor.constraint(equalTo: header.topAnchor, constant: 6).isActive = true
        datePriceSegmentedControl.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -6).isActive = true
        return header
    }()
    
    //MARK: -  Methods
    
    func navigationBarSetup() {
        
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-filter-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleFilter))
    }
    
    func tableViewSetup() {
        self.definesPresentationContext = true
        tableView.keyboardDismissMode = .onDrag
        
        refreshControle.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControle
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: SearchController.searchCellID)
        tableView.separatorStyle = .none
    }
    
    
    func fetchPostsfromFirebase() {
        
        if cityFiler == nil {
            
            Firestore.firestore().collection("users").getDocuments { (snap, err) in
                snap?.documents.forEach({ (snap) in
                    let userDictionary = snap.data()
                    let user = User(dictionary: userDictionary)
                    guard let uid = user.uid else {return}
                    Firestore.firestore().collection("posts").document(uid).collection("userPosts").getDocuments(completion: { (snap, err) in
                        snap?.documents.forEach({ (snap) in
                            let postDictionary = snap.data()
                            let post = Post(dictionary: postDictionary)
                            self.posts.append(post)
                        })
                        
                        self.posts.sort(by: { (p1, p2) -> Bool in
                            let firstPost = Int(p1.date ?? 0)
                            let secondPost = Int(p2.date ?? 0)
                            return firstPost > secondPost
                        })
                        
                        self.filteredposts = self.posts
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                })
            }
        } else {
            self.posts.removeAll()
            self.filteredposts.removeAll()
            guard let cityFilter = self.cityFiler else {return}
            Firestore.firestore().collection("location-filter").document(cityFilter).collection("current-location").getDocuments { (snap, err) in
                snap?.documents.forEach({ (snapshot) in
                    let post = Post(dictionary: snapshot.data())
                    self.posts.append(post)
                    self.filteredposts.append(post)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
}

//MARK: -  UISearchBarDelegate Methods
extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredposts = posts
        } else {
            filteredposts = posts.filter({ (post) -> Bool in
                if let title = post.title {
                    return title.lowercased().contains(searchText.lowercased())
                }
                return true
            })
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- TableView Delegate Methods
extension SearchController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredposts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchController.searchCellID, for: indexPath) as! FilterTableViewCell
        let post = self.filteredposts[indexPath.row]
        cell.post = post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetails = PostDetailsController()
        let post = filteredposts[indexPath.row]
        postDetails.post = post
        navigationController?.pushViewController(postDetails, animated: true)
    }
}


//MARK:- SearchLocationFilter Delegate Methods
extension SearchController: SearchLocationFilterDelegate {
    
    func cityLocation(of city: String) {
        self.cityFiler = city
    }
}

//MARK: - Selector objective Methods
extension SearchController {
    
    @objc func handleRefresh() {
        self.posts.removeAll()
        fetchPostsfromFirebase()
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc func handleFilter() {
        
        let searchFilter = SearchFilterController()
        searchFilter.delegate = self
        let navBar = UINavigationController(rootViewController: searchFilter)
        present(navBar, animated: true, completion: nil)
        
    }
    
    @objc func handleSegmentedControl(segmentControl: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            
            self.filteredposts.sort { (p1, p2) -> Bool in
                return p1.date! > p2.date!
            }
        } else {
            
            self.filteredposts.sort { (p1, p2) -> Bool in
                return p1.price! < p2.price!
            }
        }
        
        DispatchQueue.main.async {
            var indexPathToAnimate = [IndexPath]()
            for (index, _) in self.filteredposts.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToAnimate.append(indexPath)
            }
            self.tableView.reloadRows(at: indexPathToAnimate, with: .fade)
        }
    }
}
