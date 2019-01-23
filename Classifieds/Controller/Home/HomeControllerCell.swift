//
//  HomeControllerCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/2/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

    //MARK: - Protol
protocol HomeCellDelegate: class {
    func didTapFavorite(cell: HomeControllerCell)
//    func didTapFavorite(post: Post)
}

class HomeControllerCell: UICollectionViewCell {
    
    //MARK: - Variables
    weak var delegate: HomeCellDelegate?
    
    //MARK: - Property Observer
    var post: Post! {
        didSet {
            guard let imageUrl = post.imageUrl1 else {return}
            let url = URL(string: imageUrl)
            imageview.sd_setImage(with: url)
            priceLabel.text = "$ \(post.price ?? 0)"
            titleLabel.text = "\(self.post.title ?? "")"
            
            if post.isFavorited == true {
                favoriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-100").withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                favoriteButton.setImage(#imageLiteral(resourceName: "icons8-heart-100-2").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    //MARK: - Cell Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK:- Layout Properties
    let imageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let containerViewForHeart: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), for: .normal)
        button.alpha = 0.6
        button.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        return button
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Contraiant Methods
    func setupLayout() {
        
        
        backgroundColor = .white
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false;
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false;
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        addSubview(imageview)
        imageview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        imageview.addSubview(containerViewForHeart)
        containerViewForHeart.topAnchor.constraint(equalTo: imageview.topAnchor, constant: 8).isActive = true
        containerViewForHeart.trailingAnchor.constraint(equalTo: imageview.trailingAnchor, constant: -8).isActive = true
        containerViewForHeart.widthAnchor.constraint(equalToConstant: 40).isActive = true
        containerViewForHeart.heightAnchor.constraint(equalToConstant: 40).isActive = true

        containerViewForHeart.addSubview(favoriteButton)
        favoriteButton.centerXAnchor.constraint(equalTo: containerViewForHeart.centerXAnchor).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: containerViewForHeart.centerYAnchor).isActive = true

        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageview.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        imageview.bringSubviewToFront(favoriteButton)
        
    }
    
    @objc func handleFavorite() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        delegate?.didTapFavorite(cell: self)
        generator.impactOccurred()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
