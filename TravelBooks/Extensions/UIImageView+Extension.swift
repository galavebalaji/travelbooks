//
//  UIImageView+Extension.swift
//  TravelBooks

import Foundation
import UIKit

extension UIImageView {
    
    func roundedImage(_ cornerRadius: CGFloat, withBorder: Bool = true, color: UIColor) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = color.cgColor
        layer.cornerRadius = cornerRadius
        if withBorder {
            layer.borderColor = UIColor.white.cgColor
        }
        clipsToBounds = true
    }
}
