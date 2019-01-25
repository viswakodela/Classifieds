//
//  FilterPostsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/24/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class FilterPostsController: UICollectionViewController {
    
    private static let filterPostCellID = "filterPostCellID"
    private static let headerCellId = "filterPostHeaderCell"
    private static let footerCellId = "footerCellId"
    private static let filterPriceDateLocationCell = "filterPriceDateLocationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let city = self.city else {return}
        fetchPostsFromFirebase(city: city)
    }
    
    weak var headerCell: CustomCollectionViewHeader?
    var city: String? {
        didSet {
            headerCell?.headerLabel.text = "City: \(self.city ?? "")"
        }
    }
    var posts = [Post]() {
        didSet {
            self.filteredPosts = posts
            self.collectionView.reloadData()
        }
    }
    
    var filteredPosts = [Post]()
    
    weak var category: CategoryModel? {
        didSet {
            navigationItem.title = category?.categoryName
            let posts = self.posts.filter { (post) -> Bool in
                post.categoryName == category?.categoryName
            }
            self.filteredPosts = posts
        }
    }
    
    func fetchPostsFromFirebase(city: String) {
        self.posts.removeAll()
        self.filteredPosts.removeAll()
        Database.database().reference().child("cities").child(city).observe(.value) { (snap) in
            guard let snapDict = snap.value as? [String : Any] else {return}
            snapDict.forEach({ (key, value) in
                guard let postDict = value as? [String : Any] else {return}
                let post = Post(dictionary: postDict)
                
                if post.categoryName == self.category?.categoryName {
                    self.filteredPosts.append(post)
                }
            })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupLayout() {
        collectionView.backgroundColor = .white
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: FilterPostsController.filterPostCellID)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterPostsController.headerCellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FilterPostsController.footerCellId)
        collectionView.register(FilterPostCell.self, forCellWithReuseIdentifier: FilterPostsController.filterPriceDateLocationCell)
    }
}

extension FilterPostsController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 3 : filteredPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterPostsController.filterPostCellID, for: indexPath) as! HomeControllerCell
            
            if filteredPosts.count == 0 {
                collectionView.reloadData()
                return cell
            }
            
            let post = filteredPosts[indexPath.item]
            cell.post = post
            return cell
        } else {
            let filterPriceLocationCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterPostsController.filterPriceDateLocationCell, for: indexPath) as! FilterPostCell
            return filterPriceLocationCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 24) / 2
        return indexPath.section == 0 ? CGSize(width: (view.frame.width - 32) / 3, height: 60) : CGSize(width: width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterPostsController.headerCellId, for: indexPath) as! CustomCollectionViewHeader
                header.headerLabel.text = "Filter by:"
                header.locationLabel.isHidden = true
                return header
            } else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterPostsController.headerCellId, for: indexPath) as! CustomCollectionViewHeader
                header.headerLabel.text = "City: \(self.city ?? "")"
                self.headerCell = header
                header.locationLabel.isHidden = false
                header.locationImage.isHidden = false
                header.locationImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSearchLocation)))
                return header
            }
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterPostsController.footerCellId, for: indexPath)
            footer.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: view.frame.width, height: 20) : CGSize(width: 0, height: 0)
    }
    
    @objc func handleSearchLocation() {
        let searchLocation = SearchFilterController()
        searchLocation.delegate = self
        let navBar = UINavigationController(rootViewController: searchLocation)
        present(navBar, animated: true, completion: nil)
    }
    
}

extension FilterPostsController: SearchLocationFilterDelegate {
    
    func cityLocation(of city: String) {
        self.city = city
    }
}
