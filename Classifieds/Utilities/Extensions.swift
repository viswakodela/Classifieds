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


extension UITabBarController {
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            }.startAnimation()
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}

class CustomView: UIView {
    
    // this is needed so that the inputAccesoryView is properly sized from the auto layout constraints
    // actual value is not important
    
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
