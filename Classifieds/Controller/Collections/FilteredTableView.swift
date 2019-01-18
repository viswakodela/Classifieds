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
    
    //MARK: - Table View Cell Identifiers
    private static let tableCell = "tableCell"
    
    //MARK: - Variables
    var posts = [Post]()
    var users = [User]()
    var filteredPosts = [Post]()
    
    //MARK: -  Property Observer
    var category: CategoryModel! {
        didSet {
            navigationItem.title = category.categoryName
            let posts = self.posts.filter { (post) -> Bool in
                post.categoryName == category.categoryName
            }
            self.filteredPosts = posts
        }
    }
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
    }
    
    //MARK: - Methods
    func tableViewSetup() {
        
        tableView.separatorStyle = .none
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilteredTableView.tableCell)
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
}

//MARK: - TableView Methods
extension FilteredTableView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPosts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilteredTableView.tableCell, for: indexPath) as! FilterTableViewCell
        
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
