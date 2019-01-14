//
//  SearchController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UITableViewController {
    
    private let searchCellID = "searchCellID"
    var searchController = UISearchController(searchResultsController: nil)
    var refreshControle = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostsfromFirebase()
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.keyboardDismissMode = .onDrag
        navigationItem.searchController?.searchBar.delegate = self
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: searchCellID)
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-filter-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleFilter))
        
        refreshControle.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControle
    }
    
    @objc func handleRefresh() {
        self.posts.removeAll()
        fetchPostsfromFirebase()
        tableView.refreshControl?.endRefreshing()
    }
    
    
    var posts = [Post]()
    var users = [User]()
    var filteredposts = [Post]()
    
    func fetchPostsfromFirebase() {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").getDocuments { (snap, err) in
            snap?.documents.forEach({ (snap) in
                let userDictionary = snap.data()
                let user = User(dictionary: userDictionary)
                
                if user.uid == currentUID {
                    return
                } else {
                    self.users.append(user)
                }
                
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
    }
    
    @objc func handleFilter() {
        
    }
}


extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredposts = posts
            self.handleRefresh()
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

extension SearchController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
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
        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellID, for: indexPath) as! FilterTableViewCell
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
