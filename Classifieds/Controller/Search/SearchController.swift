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
    static let unsavePostFromSearchKey = "unsavePostFromSearchKey"
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if cityFiler != nil {
//            posts.removeAll()
//            fetchPostsfromFirebase()
//        }
//    }
    
    //MARK: - Layout Properties
    
    let datePriceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Date", "Price"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.isUserInteractionEnabled = true
        sc.layer.cornerRadius = 5
        sc.clipsToBounds = true
        sc.backgroundColor = .white
        sc.tintColor = UIColor(red: 92/255, green: 159/255, blue: 205/255, alpha: 1)
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
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-filter-100"), style: .plain, target: self, action: #selector(handleFilter))
    }
    
    func tableViewSetup() {
        self.definesPresentationContext = true
        tableView.keyboardDismissMode = .onDrag
        
        refreshControle.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControle
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: SearchController.searchCellID)
        tableView.separatorStyle = .none
    }
    
    var currentPost: String?
    var numberOfItems = 10
    var isFinishedPaging = false
    func fetchPostsfromFirebase() {
        
        if cityFiler == nil {
            
//            Database.database().reference().child("posts").observe(.childAdded) { (snap) in
//                guard let snapDict = snap.value as? [String : Any] else {return}
//                snapDict.forEach({ (key, value) in
//                    guard let postDict = value as? [String : Any] else {return}
//                    let post = Post(dictionary: postDict)
//                    
//                    let savedPosts = UserDefaults.standard.savedPosts()
//                    savedPosts.forEach({ (pst) in
//                        if pst.postId == post.postId {
//                            post.isFavorited = true
//                        }
//                    })
//                    self.posts.append(post)
//                })
//                DispatchQueue.main.async {
//                    self.filteredposts = self.posts
//                    self.tableView.reloadData()
//                }
//            }
        } else {
            
            guard let cityFilter = self.cityFiler else {return}
            let ref = Database.database().reference().child("cities").child(cityFilter)
            
            if currentPost == nil {
                self.posts.removeAll()
                self.filteredposts.removeAll()
                ref.queryOrderedByKey().queryLimited(toFirst: UInt(numberOfItems)).observe(.value) { (snap) in
                    
                    let first = snap.children.allObjects.last as! DataSnapshot
                    
                    if snap.childrenCount > 0 {
                        
                        for child in snap.children.allObjects as! [DataSnapshot] {
                            
                            let item = child.value as! [String : Any]
                            let post = Post(dictionary: item)
                            
                            let savedPosts = UserDefaults.standard.savedPosts()
                            savedPosts.forEach({ (pst) in
                                if pst.postId == post.postId {
                                    post.isFavorited = true
                                }
                            })
                            
                            self.posts.append(post)
                        }
                        self.filteredposts = self.posts
                        self.currentPost = first.key
                        self.tableView.reloadData()
                    }
                }
            } else {
                
                ref.queryOrderedByKey().queryStarting(atValue: currentPost).queryLimited(toFirst: 10).observeSingleEvent(of: .value) { (snap) in
                    
                    guard let first = snap.children.allObjects.last as? DataSnapshot else {return}
                    let index = self.posts.count
                    if snap.children.allObjects.count < 10 {
                        self.isFinishedPaging = true
                    }
                    if snap.childrenCount > 0 {
                        for child in snap.children.allObjects as! [DataSnapshot] {
                            
                            if child.key != self.currentPost {
                                let item = child.value as! [String : Any]
                                let post = Post(dictionary: item)
                                
                                let savedPosts = UserDefaults.standard.savedPosts()
                                savedPosts.forEach({ (pst) in
                                    if pst.postId == post.postId {
                                        post.isFavorited = true
                                    }
                                })
                                
                                self.posts.append(post)
                            }
                        }
                        self.filteredposts = self.posts
                        self.currentPost = first.key
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let contentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        
        if maxOffset - contentOffset <= 50 && isFinishedPaging == false {
            fetchPostsfromFirebase()
        }
    }
}

//MARK: -  UISearchBarDelegate Methods
extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredposts = posts
        } else {
            
            let indx = datePriceSegmentedControl.selectedSegmentIndex
            filteredposts = posts.filter({ (post) -> Bool in
                if let title = post.title {
                    return title.lowercased().contains(searchText.lowercased())
                }
                return true
            })
            if indx == 0 {
                filteredposts.sort { (p1, p2) -> Bool in
                    return Double(p1.date!) > Double(p2.date!)
                }
            } else {
                filteredposts.sort { (p1, p2) -> Bool in
                    return p1.price! < p2.price!
                }
            }
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
        posts.removeAll()
        filteredposts.removeAll()
        isFinishedPaging = false
        currentPost = nil
        fetchPostsfromFirebase()
    }
}

//MARK: - Selector objective Methods
extension SearchController {
    
    @objc func handleRefresh() {
        
        let deadLine = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            if self.cityFiler != nil {
                self.fetchPostsfromFirebase()
                self.refreshControle.endRefreshing()
                return
            }
            self.refreshControle.endRefreshing()
        }
    }
    
    @objc func handleFilter() {
        
        let searchFilter = SearchFilterController()
        searchFilter.delegate = self
        let navBar = UINavigationController(rootViewController: searchFilter)
        present(navBar, animated: true, completion: nil)
        
    }
    
    @objc func handleSegmentedControl(segmentControl: UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex == 0 {
            
            if filteredposts.isEmpty {
                tableView.reloadData()
                return
            }
            
            self.filteredposts.sort { (p1, p2) -> Bool in
                return p1.date! > p2.date!
            }
        } else {
            
            if filteredposts.isEmpty {
                tableView.reloadData()
                return
            }
            
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
