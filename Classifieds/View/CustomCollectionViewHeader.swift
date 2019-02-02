//
//  CustomCollectionViewHeader.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/31/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class CustomCollectionViewHeader: UICollectionViewCell {
    
    weak var homeController: HomeController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLocationChange)))
        return label
    }()
    
    lazy var locationImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "icons8-marker-100").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.isHidden = true
        return iv
    }()
    
    @objc func handleLocationChange() {
        self.homeController?.handlingLocationChange()
    }
    
    func setupViews() {
        addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        headerLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        addSubview(locationLabel)
        locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        locationLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        locationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        locationLabel.addSubview(locationImage)
        locationImage.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor).isActive = true
        locationImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        locationImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        locationImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
