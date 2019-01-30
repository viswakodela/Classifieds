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
    }
    
    weak var headerCell: CustomCollectionViewHeader?
    var city: String?
    var posts = [Post]() {
        didSet {
            posts.forEach { (post) in
                if post.categoryName == self.category?.categoryName {
                    self.filteredPosts.append(post)
                }
            }
            self.collectionView.reloadData()
        }
    }
    var filteredPosts = [Post]()
    
    var isFinishedPaging = false
    var numberOfItems = 5
    var currentPost: String?
    
    var category: CategoryModel? {
        didSet {
            navigationItem.title = category?.categoryName
            guard let city = self.city else {return}
            self.fetchPostsFromFirebase(city: city)
        }
    }
    
    func fetchPostsFromFirebase(city: String) {
        
//        let ref = Database.database().reference().child("cities").child(city)
//
//        if currentPost == nil {
//
//            ref.queryOrderedByKey().queryLimited(toLast: 5).observe(.value) { (snap) in
//                let snapshot = snap.children.allObjects as! [DataSnapshot]
//
//                guard let firstKey = snapshot.first else {return}
//
//                if snap.childrenCount > 0 {
//
//                    for child in snapshot {
//
//                        let item = child.value as! [String : Any]
//                        let post = Post(dictionary: item)
//
//                        let savedPosts = UserDefaults.standard.savedPosts()
//                        savedPosts.forEach({ (pst) in
//                            if pst.postId == post.postId {
//                                post.isFavorited = true
//                            }
//                        })
//                        self.filteredPosts.append(post)
//                    }
//                    self.currentPost = firstKey.key
//                    self.collectionView.reloadData()
//                }
//            }
//        } else {
//            ref.queryOrderedByKey().queryEnding(atValue: currentPost).queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snap) in
//
//                let snapshot = snap.children.allObjects as! [DataSnapshot]
//
//                guard let firstKey = snapshot.first else {return}
//                //                let index = self.postsArray.count
//                if snapshot.count < 5 {
//                    self.isFinishedPaging = true
//                }
//                if snap.childrenCount > 0 {
//                    for child in snap.children.allObjects as! [DataSnapshot] {
//
//                        if child.key != self.currentPost {
//                            let item = child.value as! [String : Any]
//                            let post = Post(dictionary: item)
//
//                            let savedPosts = UserDefaults.standard.savedPosts()
//                            savedPosts.forEach({ (pst) in
//                                if pst.postId == post.postId {
//                                    post.isFavorited = true
//                                }
//                            })
//                            self.filteredPosts.append(post)
//                        }
//                    }
//                    self.currentPost = firstKey.key
//                    self.collectionView.reloadData()
//                }
//            }
//        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        
        if maxOffset - contentOffset <= 4 && isFinishedPaging == false {
            self.fetchPostsFromFirebase(city: self.city!)
        }
    }
    
    func setupLayout() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeControllerCell.self, forCellWithReuseIdentifier: FilterPostsController.filterPostCellID)
        collectionView.register(CustomCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterPostsController.headerCellId)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FilterPostsController.footerCellId)
        collectionView.register(FilterPostCell.self, forCellWithReuseIdentifier: FilterPostsController.filterPriceDateLocationCell)
    }
}

extension FilterPostsController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPosts.count
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
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterPostsController.filterPostCellID, for: indexPath) as! HomeControllerCell
            
            if filteredPosts.count == 0 {
                collectionView.reloadData()
                return cell
            }
            
            let post = filteredPosts[indexPath.item]
            cell.post = post
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 24) / 2
        return CGSize(width: width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterPostsController.headerCellId, for: indexPath) as! CustomCollectionViewHeader
            header.headerLabel.text = "City: \(self.city ?? "")"
            self.headerCell = header
            header.locationLabel.isHidden = false
            header.locationImage.isHidden = false
            header.locationImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSearchLocation)))
            return header
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
