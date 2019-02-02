//
//  UIColor+Extension.swift
//  TravelBooks

import Foundation
import UIKit

extension UIColor {
    
    class func navigationTint() -> UIColor {
        return .black
    }
    
    class func navigationBarBackground() -> UIColor {
        return .white
    }
    
    class func travelFeedCellBorder() -> UIColor {
        return #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    }
    
    class func travelFeedTableViewBackground() -> UIColor {
        return #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
    }
    
    class func travelFeedCellUserName() -> UIColor {
        return UIColor.colorWithHexString(hexString: "#383E39")
    }
}

extension UIColor {
    
    static func colorWithHexString (hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
