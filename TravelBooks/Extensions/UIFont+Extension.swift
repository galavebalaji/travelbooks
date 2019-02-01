//
//  UIFont+Extension.swift
//  TravelBooks

import Foundation
import UIKit

extension UIFont {
    
    enum MontserratFontWeight {
        case regular, black, bold, extraBold, hairline, light, semiBold, ultraLight
    }
    
    class func montserratFont(ofSize fontSize: CGFloat, weight: MontserratFontWeight) -> UIFont {
        
        var font: UIFont?
        
        switch weight {
        case .regular:
            font = UIFont(name: "Montserrat-Regular", size: fontSize)
        case .black:
            font = UIFont(name: "Montserrat-Black", size: fontSize)
        case .bold:
            font = UIFont(name: "Montserrat-Bold", size: fontSize)
        case .extraBold:
            font = UIFont(name: "Montserrat-ExtraBold", size: fontSize)
        case .hairline:
            font = UIFont(name: "Montserrat-Hairline", size: fontSize)
        case .light:
            font = UIFont(name: "Montserrat-Light", size: fontSize)
        case .semiBold:
            font = UIFont(name: "Montserrat-SemiBold", size: fontSize)
        case .ultraLight:
            font = UIFont(name: "Montserrat-UltraLight", size: fontSize)
        }
        
        return font ?? UIFont.systemFont(ofSize: fontSize)
    }
}
