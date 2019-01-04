//
//  PostDetailsController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/3/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class PostDetailsController: UIViewController {
    
    private let imageCellId = "imageCellId"
    
    var posts: Post! {
        didSet {
            if posts.imageUrl1 != nil {
                self.imagesArray.append(posts!.imageUrl1!)
            }
            if posts.imageUrl2 != nil {
                self.imagesArray.append(posts!.imageUrl2!)
            }
            if posts.imageUrl3 != nil {
                self.imagesArray.append(posts!.imageUrl3!)
            }
            if posts.imageUrl4 != nil {
                self.imagesArray.append(posts!.imageUrl4!)
            }
            if posts.imageUrl5 != nil {
                self.imagesArray.append(posts!.imageUrl5!)
            }
            titleLabel.text = posts.title
            descriptionView.text = posts.description
            collectionView.reloadData()
        }
    }
    
    var imagesArray = [String]()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.contentSize.height = 1200
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        sv.isPagingEnabled = true
        return sv
    }()
    
    let vieww: UIView = {
        let iv = UIView()
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = imagesArray.count
        pc.currentPage = 0
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .lightGray
        pc.hidesForSinglePage = true
        return pc
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.sizeToFit()
        tv.numberOfLines = 0
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        collectionView.register(PostImageCell.self, forCellWithReuseIdentifier: imageCellId)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        vieww.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1000).isActive = true
        
        scrollView.addSubview(vieww)
        
        vieww.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: vieww.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: vieww.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: vieww.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: vieww.bottomAnchor).isActive = true
        
        vieww.addSubview(pageControl)
        pageControl.leadingAnchor.constraint(equalTo: vieww.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: vieww.trailingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: vieww.bottomAnchor).isActive = true
        
        scrollView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: vieww.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        scrollView.addSubview(descriptionView)
        descriptionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        descriptionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension PostDetailsController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let changeY = -scrollView.contentOffset.y
//        var width = view.frame.width + changeY * 2
//        width = max(width, view.frame.width)
//
//        vieww.frame = CGRect(x: 0, y: 0, width: width, height: width)
//
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
}

extension PostDetailsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! PostImageCell
        let image = imagesArray[indexPath.item]
        print(image)
        cell.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
}

