//
//  ChooseCategoryController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/27/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

protocol ChooseCategoryDelegate: class {
    func didChooseCategory(categoryName: String)
}

class ChooseCategoryController: UITableViewController {
    
    //MARK: - Constants
    private static let chooseCategoryCellId = "chooseCategoryCellId"
    let caterories = ColletionsViewController.shared.collectionsArray
    
    //MARK: - Delegate
    weak var delegate: ChooseCategoryDelegate?
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAndNavigationBarSetup()
    }
    
    //MARK: - Methods
    func tableViewAndNavigationBarSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ChooseCategoryController.chooseCategoryCellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    //MARK: - TableView Delgate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caterories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCategoryController.chooseCategoryCellId, for: indexPath)
        cell.textLabel?.text = caterories[indexPath.row].categoryName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = caterories[indexPath.row]
        guard let categoryName = category.categoryName else {return}
        delegate?.didChooseCategory(categoryName: categoryName)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
