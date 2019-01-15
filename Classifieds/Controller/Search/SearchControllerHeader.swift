//
//  SearchControllerHeader.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/14/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

protocol SeactionHeaderDelegate: class {
    func selectedIndex(index: Int, segmentControl: UISegmentedControl)
}

class SearchControllerHeader: UIView {
    
    weak var delegate: SeactionHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let datePriceSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Date", "Price"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.isUserInteractionEnabled = true
        sc.layer.cornerRadius = 5
        sc.clipsToBounds = true
        sc.backgroundColor = .white
        sc.tintColor = .black
        sc.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
        return sc
    }()
    
    @objc func handleSegmentedControl(segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
        case 0:
            delegate?.selectedIndex(index: 0, segmentControl: segControl)
            break
        default:
            delegate?.selectedIndex(index: 1, segmentControl: segControl)
            break
        }
    }
    
    func setupViews() {
        backgroundColor = .white
        addSubview(datePriceSegmentedControl)
        datePriceSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        datePriceSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        datePriceSegmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        datePriceSegmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
