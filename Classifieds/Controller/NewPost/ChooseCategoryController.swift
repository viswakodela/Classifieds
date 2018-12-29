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
    
    private let chooseCategoryCellId = "chooseCategoryCellId"
    
    weak var delegate: ChooseCategoryDelegate?
    
    let caterories = ColletionsViewController.shared.collectionsArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: chooseCategoryCellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caterories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chooseCategoryCellId, for: indexPath)
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
