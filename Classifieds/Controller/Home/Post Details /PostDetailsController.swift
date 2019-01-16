//
//  PostDetailsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/3/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PostDetailsController: UIViewController {
    
    //MARK: - Cell Identifiers
    private let normalCell = "normalCell"
    private let tableViewCell1 = "tableViewCell1"
    private let tableViewCell2 = "tableViewCell2"
    private let tableViewCell3 = "tableViewCell3"
    private let tableViewCell4 = "tableViewCell4"
    private let tableViewCell5 = "tableViewCell5"
    private let tableViewCell6 = "tableViewCell6"
    private static let priceLabelCell = "priceLabelCell"
    
    //MARK: - Variables
    var imagesArray = [String]()
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        tableViewSetUp()
        navigationBarSetup()

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Property Observer
    var post: Post! {
        didSet {
            navigationItem.title = post.title
            if post.imageUrl1 != nil {
                self.imagesArray.append(post.imageUrl1!)
            }
            if post.imageUrl2 != nil {
                self.imagesArray.append(post.imageUrl2!)
            }
            if post.imageUrl3 != nil {
                self.imagesArray.append(post.imageUrl3!)
            }
            if post.imageUrl4 != nil {
                self.imagesArray.append(post.imageUrl4!)
            }
            if post.imageUrl5 != nil {
                self.imagesArray.append(post.imageUrl5!)
            }
        }
    }
    
    //MARK: -  Layout Properties
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 50
        tv.allowsSelection = false
        tv.autoresizesSubviews = true
        return tv
    }()
    
    //MARK: - Methods
    func tableViewSetUp() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: normalCell)
        tableView.register(FirstTableViewCell.self, forCellReuseIdentifier: tableViewCell1)
        tableView.register(SecondTableViewCell.self, forCellReuseIdentifier: tableViewCell2)
        tableView.register(ThirdTableViewCell.self, forCellReuseIdentifier: tableViewCell3)
        tableView.register(FourthTableCell.self, forCellReuseIdentifier: tableViewCell4)
        tableView.register(FifthTableCell.self, forCellReuseIdentifier: tableViewCell5)
        tableView.register(SixthTableCell.self, forCellReuseIdentifier: tableViewCell6)
        tableView.register(PriceLabelCell.self, forCellReuseIdentifier: PostDetailsController.priceLabelCell)
    }
    
    func navigationBarSetup() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupLayout() {
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK:- TableViewMethods

extension PostDetailsController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.frame.width
        }  else if indexPath.section == 3 { // SellerInformation Cell
            return 70
        } else if indexPath.section == 5  { // MapView Cell
            return 194
        } else  if indexPath.section == 6 {
            return 140
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let firstTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell1, for: indexPath) as! FirstTableViewCell
            firstTableViewCell.imagesArray = self.imagesArray
            return firstTableViewCell
            
        } else if indexPath.section == 1 {
            
            let secondTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell2, for: indexPath) as! SecondTableViewCell
            secondTableViewCell.post = self.post
            return secondTableViewCell
            
        } else  if indexPath.section == 2 {
            
            let priceCell = tableView.dequeueReusableCell(withIdentifier: PostDetailsController.priceLabelCell, for: indexPath) as! PriceLabelCell
            priceCell.post = self.post
            return priceCell
        } else if indexPath.section == 3 {
            
            let thirdTableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell3, for: indexPath) as! ThirdTableViewCell
            thirdTableViewCell.post = self.post
            return thirdTableViewCell
            
        } else if indexPath.section == 4 {
            
            let fourthCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell4, for: indexPath) as! FourthTableCell
            fourthCell.post = self.post
            return fourthCell
            
        } else if indexPath.section == 5 {
            
            let fifthCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell5, for: indexPath) as! FifthTableCell
            fifthCell.post = post
            return fifthCell
            
        } else if indexPath.section == 6 {
            let sixthCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell6, for: indexPath) as! SixthTableCell
            sixthCell.post = post
            sixthCell.postDetails = self
            return sixthCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: normalCell, for: indexPath)
        let attributedText = NSMutableAttributedString(string: String("  $\(post.price ?? 0)"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor(red: 65/255, green: 165/255, blue: 122/255, alpha: 1)])
        cell.textLabel?.attributedText = attributedText
        return cell
    }
    
    func pushToNewDetailsFromSixthCell(post: Post) {
        let postDetails = PostDetailsController()
        postDetails.post = post
        navigationController?.pushViewController(postDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            tableView.allowsSelection = true
        }
    }
}

