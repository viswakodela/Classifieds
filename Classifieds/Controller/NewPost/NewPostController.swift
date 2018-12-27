//
//  NewPostController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/26/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class NewPostController: UITableViewController, NewCell2Delegate, ChooseCategoryDelegate {
    
    
    var cell: NewPostCell2?
    var indexPath: IndexPath?
    func buttonTapped(indexPath: IndexPath, selector: Selector) {
        self.indexPath = indexPath
        if indexPath.row == 0 {
            var textFild = UITextField()
            let alert = UIAlertController(title: "Enter Price (e.g. $150)", message: "", preferredStyle: .alert)
            let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Enter"
                textFild = textField
            }
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                guard let text = textFild.text else {return}
                self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell2
                self.cell?.rightButton.setTitle("$\(text)", for: .normal)
                self.tableView.reloadData()
            }
            alert.addAction(cancelaction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        if indexPath.row == 1 {
            let chooseCategoryController = ChooseCategoryController()
            chooseCategoryController.delegate = self
            let navBarChooseController = UINavigationController(rootViewController: chooseCategoryController)
            present(navBarChooseController, animated: true, completion: nil)
        }
        
        if indexPath.row == 2 {
            let mapViewController = MapViewController()
            present(mapViewController, animated: true, completion: nil)
        }
    }
    
    func didChooseCategory(categoryName: String) {
        print(categoryName)
        guard let indexPath = self.indexPath else {return}
        self.cell = self.tableView.cellForRow(at: indexPath) as? NewPostCell2
        cell?.rightButton.setTitle(categoryName, for: .normal)
        self.tableView.reloadData()
    }
    
    
    private let cellId = "cellId"
    private let newPost1CellId = "newPost1CellId"
    private let newPost2CellId = "newPost2CellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        navigationItem.title = "Add Listing"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        tableView.register(NewPostCell1.self, forCellReuseIdentifier: newPost1CellId)
        tableView.register(NewPostCell2.self, forCellReuseIdentifier: newPost2CellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewPostController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        default: break
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 0 : 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 1 ? 1 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: newPost2CellId, for: indexPath) as! NewPostCell2
            cell.newPost2Delegate = self
            cell.indexPath = indexPath
            if indexPath.row == 0 {
                cell.leftLabel.text = "Price"
            } else if indexPath.row == 1 {
                cell.leftLabel.text = "Category"
            } else {
                cell.leftLabel.text = "Location"
            }
            return cell
        }
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: newPost1CellId, for: indexPath) as! NewPostCell1
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: newPost1CellId, for: indexPath) as! NewPostCell1
            break
        default :
            break
        }
        return cell
    }
}
