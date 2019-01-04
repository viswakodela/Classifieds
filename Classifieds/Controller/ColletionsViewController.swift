//
//  ColletionsViewController.swift
//  Classifieds
//
//  Created by Viswa Kodela on 12/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class ColletionsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let collectionCell = "collectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(CollectionsCell.self, forCellWithReuseIdentifier: collectionCell)
    }
    
    static let shared = ColletionsViewController()
    
    let collectionsArray = [CategoryModel(image: #imageLiteral(resourceName: "phones"), categoryName: "Phones & Tablets"),
                            CategoryModel(image: #imageLiteral(resourceName: "rooms"), categoryName: "Roomes/Beds"),
                            CategoryModel(image: #imageLiteral(resourceName: "bookmark-bowl-business-705675"), categoryName: "Laptops"),
                            CategoryModel(image: #imageLiteral(resourceName: "jobs"), categoryName: "Jobs & Services"),
                            CategoryModel(image: #imageLiteral(resourceName: "furniture"), categoryName: "Furniture"),
                            CategoryModel(image: #imageLiteral(resourceName: "automobile-automotive-car-116675"), categoryName: "Cars")
                            ]
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCell, for: indexPath) as! CollectionsCell
        cell.categoryModel = collectionsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 200)
    }

}
