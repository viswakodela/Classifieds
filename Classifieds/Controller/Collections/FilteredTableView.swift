//
//  FilteredTableView.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/7/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class FilteredTableView: UITableViewController {
    
    
    private let tableCell = "tableCell"
    var category: CategoryModel! {
        didSet {
            navigationItem.title = category.categoryName
            posts.forEach { (post) in
                if post.categoryName == category?.categoryName {
                    self.filteredPosts.append(post)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var posts = [Post]()
    var users = [User]()
    
    var filteredPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-back-100").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: tableCell)
//        fetchPosts()
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    func fetchPosts() {
        let query = Firestore.firestore().collection("users")
        query.getDocuments { (snap, err) in
            if let error = err {
                self.showProgressHUD(error: error)
                return
            }
            guard let snapshot = snap else {return}
            
            snapshot.documents.forEach({ (snapshot) in
                let userDictionary = snapshot.data()
                let user = User(dictionary: userDictionary)
                self.users.append(user)
                guard let uid = user.uid else {return}
                Firestore.firestore().collection("posts").document(uid).collection("userPosts").getDocuments(completion: { (snap, err) in
                    if let error = err {
                        self.showProgressHUD(error: error)
                    }
                    guard let snapshot = snap else {return}
                    snapshot.documents.forEach({ (snapshot) in
                        
                        let postDictionbary = snapshot.data()
                        let post = Post(dictionary: postDictionbary)
                        self.posts.append(post)
                        if let category = self.category.categoryName {
                            if post.categoryName == category {
                                self.filteredPosts.append(post)
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                })
            })
        }
    }
}

extension FilteredTableView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCell, for: indexPath) as! FilterTableViewCell
        
        if filteredPosts.count == 0 {
            tableView.reloadData()
            return cell
        }
        
        let post = filteredPosts[indexPath.row]
        cell.post = post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetails = PostDetailsController()
        let post = filteredPosts[indexPath.row]
        postDetails.post = post
        navigationController?.pushViewController(postDetails, animated: true)
    }
}
