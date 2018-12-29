//
//  NewPostController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/26/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class NewPostController: UITableViewController, ChooseCategoryDelegate, MapControllerDelegate {
    
    var post = Post()
    var cell: NewPostCell2?
    var user: User! {
        didSet {
            print(user.name ?? "")
        }
    }
    
    private let cellId = "cellId"
    private let newPost1CellId = "newPost1CellId"
    private let newPost2CellId = "newPost2CellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePostToFirebase))
    }
    
    func showProgressHUD(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    @objc fileprivate func savePostToFirebase() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Posting the ad"
        hud.show(in: self.view)
        
        let postData = [
            "title" : self.post.title,
            "description" : self.post.description,
            "price" : self.post.price,
            "categoryName" : self.post.categoryName,
            "location" : self.post.location,
            "uid" : self.user.uid
        ] as! [String : Any]
        
        guard let uid = self.user.uid else {return}
        let postId = UUID().uuidString
    Firestore.firestore().collection("posts").document(uid).collection("userPosts").document(postId).setData(postData) { (err) in
            if let error = err {
                print(error)
            }
        hud.dismiss(afterDelay: 3)
        }
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupLayout() {
        tableView.keyboardDismissMode = .interactive
        navigationItem.title = "Add Listing"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        tableView.register(NewPostCell1.self, forCellReuseIdentifier: newPost1CellId)
        tableView.register(NewPostCell2.self, forCellReuseIdentifier: newPost2CellId)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePriceButton() {
        var textFild = UITextField()
        let alert = UIAlertController(title: "Enter Price (e.g. $150)", message: "", preferredStyle: .alert)
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter"
            textFild = textField
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            guard let text = textFild.text else {return}
            let priceText = Int(text)
            let indexPath = IndexPath(row: 0, section: 2)
            self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell2

            if priceText == nil {
                self.cell?.textField.text = nil
            } else {
                self.cell?.textField.text = "$\(text)"
                self.tableView.reloadData()
            }
            self.post.price = priceText
        }
        alert.addAction(cancelaction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleCategoryButton() {
        let chooseCategoryController = ChooseCategoryController()
        chooseCategoryController.delegate = self
        let navBarChooseController = UINavigationController(rootViewController: chooseCategoryController)
        present(navBarChooseController, animated: true, completion: nil)
    }
    
    func didChooseCategory(categoryName: String) {
        let indexPath = IndexPath(row: 0, section: 3)
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell2
        cell?.textField.text = categoryName
        self.post.categoryName = categoryName
        self.tableView.reloadData()
    }

    
    @objc func handleLocationButton() {
        let mapController = MapViewController()
        mapController.delegate = self
        let navController = UINavigationController(rootViewController: mapController)
        present(navController, animated: true)
    }
    
    func didTapRow(location: String) {
        let indexPath = IndexPath(row: 0, section: 4)
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell2
        cell?.textField.text = location
        print(location)
        self.post.location = location
        self.tableView.reloadData()
    }
}

extension NewPostController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderLabel()
        header.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        switch section {
        case 0:
            header.text = "Title"
            break
        case 1:
            header.text = "Description"
            break
        case 2:
            header.text = "Price"
            break
        case 3:
            header.text = "Category"
            break
        case 4:
            header.text = "Location"
        default: break
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost1CellId, for: indexPath) as! NewPostCell1
            cell.textView.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost1CellId, for: indexPath) as! NewPostCell1
            cell.textView.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost2CellId, for: indexPath) as! NewPostCell2
            cell.indexPath = indexPath
            cell.textField.addTarget(self, action: #selector(handlePriceButton), for: .allEvents)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost2CellId, for: indexPath) as! NewPostCell2
            cell.indexPath = indexPath
            cell.textField.addTarget(self, action: #selector(handleCategoryButton), for: .allEvents)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost2CellId, for: indexPath) as! NewPostCell2
            cell.indexPath = indexPath
            cell.textField.addTarget(self, action: #selector(handleLocationButton), for: .allEvents)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension NewPostController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor ==  .gray {
            textView.text = nil
            textView.textColor = .black
        } else {
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.post.title != nil {
            self.post.description = textView.text
        }else {
            self.post.title = textView.text
        }
    }
}
