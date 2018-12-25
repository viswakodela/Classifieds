//
//  HomeHeader.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class HomeHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    private let popularCategoryCell = "popularCategoryCell"
    
    let categoriesArray = [CategoryModel(image: #imageLiteral(resourceName: "phones"), categoryName: "Phones & Tablets"),
                           CategoryModel(image: #imageLiteral(resourceName: "rooms"), categoryName: "Roomes/Beds"),
                           CategoryModel(image: #imageLiteral(resourceName: "laptops"), categoryName: "Laptops"),
                           CategoryModel(image: #imageLiteral(resourceName: "jobs"), categoryName: "Jobs & Services"),
                           CategoryModel(image: #imageLiteral(resourceName: "furniture"), categoryName: "Furniture"),
                           CategoryModel(image: #imageLiteral(resourceName: "cars"), categoryName: "Cars")
                           ]
    
    lazy var collectionVie: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Popular Categories"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionVie.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionVie.register(CategoryCell.self, forCellWithReuseIdentifier: popularCategoryCell)
        setupView()
    }
    
    fileprivate func setupView() {
        let stackView = UIStackView(arrangedSubviews: [categoryLabel, collectionVie])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: popularCategoryCell, for: indexPath) as! CategoryCell
        cell.categoryModel = categoriesArray[indexPath.item]
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Tapped")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
