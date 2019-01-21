//
//  ButtomUpController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/5/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class BottomUpController: UITableViewController {
    
    //MARK:- Constants
    private let bottomId = "bottomId"
    
    //MARK: - Variables
    var post: Post?
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BottomControllerCell.self, forCellReuseIdentifier: bottomId)
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}


//MARK: - TableView Delegate Methods

extension BottomUpController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bottomId, for: indexPath) as! BottomControllerCell
        cell.post = post
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetails = PostDetailsController()
        postDetails.post = self.post
        navigationController?.pushViewController(postDetails, animated: true)
    }
}
