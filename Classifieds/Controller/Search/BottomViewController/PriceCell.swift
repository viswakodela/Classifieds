//
//  PriceCell.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/30/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

class PriceCell: UITableViewCell {
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel! {
        didSet {
            guard let slider = self.slider else {return}
            let value = Int(slider.value)
            maxLabel.text = String(value)
        }
    }
    
    @IBOutlet weak var slider: UISlider!
    @IBAction func sliderValueChange(_ sender: Any) {
        let value = Int(slider.value)
        self.maxLabel.text = String(value)
    }
}
