//
//  Extensions.swift
//  Classifieds
//
//  Created by Viswa Kodela on 1/7/19.
//  Copyright © 2019 Viswa Kodela. All rights reserved.
//

import UIKit

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

extension Date {
    
    func timeAgoDisplay() -> String {
        
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let quotient: Int
        let unit: String
        
        let minute = 60
        let hour  = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if secondsAgo < minute {
            quotient =  secondsAgo
            unit = "seconds"
        }
        else if secondsAgo < hour{
            quotient =  secondsAgo / minute
            unit = "minute"
        }
        else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        }
        else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        }
        else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        }
        else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "month"
        }
        else{
            quotient = secondsAgo / year
            unit = "year"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
        
    }
    
}
