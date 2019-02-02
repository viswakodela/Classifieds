//
//  BottomViewOfSearchController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/31/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

protocol BottomViewDelegate: class {
    func userFilteredOptions(price: Int)
}

class BottomViewOfSearchController: UITableViewController {
    
    //MARK: -  Static Properties
    private static let priceCellId = "priceCellId"
    private static let saveCellId = "saveCellId"
    
    //MARK: -  Variables
    weak var delegate: BottomViewDelegate?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
    }
    
    //MARK: - Methods
    func tableViewSetup() {
        
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 0.8
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        let priceNib = UINib(nibName: "PriceCell", bundle: nil)
        tableView.register(priceNib.self, forCellReuseIdentifier: BottomViewOfSearchController.priceCellId)
        tableView.register(SaveCell.self, forCellReuseIdentifier: BottomViewOfSearchController.saveCellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let priceCell = tableView.dequeueReusableCell(withIdentifier: BottomViewOfSearchController.priceCellId, for: indexPath) as! PriceCell
            return priceCell
        } else {
            let saveCell = tableView.dequeueReusableCell(withIdentifier: BottomViewOfSearchController.saveCellId, for: indexPath) as! SaveCell
            saveCell.saveButton.addTarget(self, action: #selector(handleSaveButtonTap), for: .touchUpInside)
            return saveCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 30 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderLabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.font = UIFont.boldSystemFont(ofSize: 16)
        
        if section == 0 {
            header.text = "Price"
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func handleSaveButtonTap() {
        let indexPath = IndexPath(row: 0, section: 0)
        let priceCell = tableView.cellForRow(at: indexPath) as! PriceCell
        guard let price = Int(priceCell.maxLabel.text!)else {return}
        
        delegate?.userFilteredOptions(price: Int(price))
    }
}
