//
//  SixthTableCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/12/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase

class SixthTableCell: UITableViewCell {
    
    var postDetails: PostDetailsController?
    let otherPostsCell = "otherPostsCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: otherPostsCell)
        setupLayout()
    }
    
    var posts = [Post]()
    
    var post: Post! {
        didSet {
            guard let sellerID = post.uid else {return}
            Firestore.firestore().collection("posts").document(sellerID).collection("userPosts").getDocuments { (snap, err) in
                snap?.documents.forEach({ (snapshot) in
                    let postDictionary = snapshot.data()
                    let post = Post(dictionary: postDictionary)
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
    
    func setupLayout() {
        
        addSubview(otherPostsLabel)
        otherPostsLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        otherPostsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        otherPostsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        otherPostsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: otherPostsLabel.bottomAnchor, constant: 4).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SixthTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: otherPostsCell, for: indexPath) as! PostImageCell
        let post = self.posts[indexPath.row]
        cell.image = post.imageUrl1
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
