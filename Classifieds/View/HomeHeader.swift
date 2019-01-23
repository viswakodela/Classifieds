//
//  HomeHeader.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class HomeHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var homeController: HomeController?
    private static let popularCategoryCell = "popularCategoryCell"
    
    let categoriesArray = [CategoryModel(image: #imageLiteral(resourceName: "phones"), categoryName: "Phones & Tablets"),
                           CategoryModel(image: #imageLiteral(resourceName: "rooms"), categoryName: "Roomes/Beds"),
                           CategoryModel(image: #imageLiteral(resourceName: "bookmark-bowl-business-705675"), categoryName: "Laptops"),
                           CategoryModel(image: #imageLiteral(resourceName: "jobs"), categoryName: "Jobs & Services"),
                           CategoryModel(image: #imageLiteral(resourceName: "furniture"), categoryName: "Furniture"),
                           CategoryModel(image: #imageLiteral(resourceName: "automobile-automotive-car-116675"), categoryName: "Cars")
                           ]
    
    lazy var collectionVie: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  Popular Categories"
        label.textColor = UIColor(red: 64/255, green: 63/255, blue: 63/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        collectionViewSetup()
    }
    
    func collectionViewSetup() {
        
        collectionVie.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionVie.register(CategoryCell.self, forCellWithReuseIdentifier: HomeHeader.popularCategoryCell)
    }
    
    fileprivate func setupView() {
        let stackView = UIStackView(arrangedSubviews: [categoryLabel, collectionVie])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        
        addSubview(stackView)
        categoryLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
//        addSubview(seperatorView)
//        seperatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
//        seperatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
//        seperatorView.heightAnchor.constraint(equalToConstant: 0.2).isActive = true
//        seperatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeader.popularCategoryCell, for: indexPath) as! CategoryCell
        cell.categoryModel = categoriesArray[indexPath.item]
        
        cell.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false;
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 0)
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected")
        let selectedCategory = self.categoriesArray[indexPath.item]
        homeController?.showHomeHeaderPush(catergory: selectedCategory)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
