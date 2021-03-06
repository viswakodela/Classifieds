//
//  SixthTableCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class OtherPostsFromSellerCell: UITableViewCell {
    
    //MARK: - Cell Identifier
    let otherPostsCell = "otherPostsCell"
    
    //MARK: - Variables
    weak var postDetails: PostDetailsController?
    var posts = [Post]()
    
    
    //MARK: - Cell Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: otherPostsCell)
        setupLayout()
    }
    
    //MARK: - Property Observer
    weak var post: Post! {
        didSet {
            guard let sellerID = post.uid else {return}
            
            Database.database().reference().child("posts").child(sellerID).observe(.value) { (snap) in
                guard let snapDict = snap.value as? [String : Any] else {return}
                
                snapDict.forEach({ (key, value) in
                    
                    guard let postDict = value as? [String : Any] else {return}
                    let post = Post(dictionary: postDict)
                    if post.postId == self.post.postId {
                        return
                    } else if self.posts.contains(where: {$0.postId == post.postId}){
                        return
                    }
                    self.posts.append(post)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                })
            }
        }
    }
    
    //MARK: - Layout Properties
    let otherPostsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Other Postings from this User"
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    //MARK: - Methods
    func setupLayout() {
        addSubview(otherPostsLabel)
        otherPostsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        otherPostsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        otherPostsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        otherPostsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: otherPostsLabel.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Collection View Delegate and DataSource Methods
extension OtherPostsFromSellerCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherPostsCell, for: indexPath) as! PostImageCell
        let post = self.posts[indexPath.row]
        cell.image = post.imageUrl1
        cell.layer.cornerRadius = 4
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        postDetails?.pushToNewDetailsFromSixthCell(post: post)
    }
}
