//
//  UIView+Extension.swift
//  TravelBooks

import Foundation
import UIKit

extension UIView {
    
    func rounded(_ cornerRadius: CGFloat, withBorder: Bool = true, borderColor: UIColor, borderWidth: CGFloat = 0) {
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        if withBorder {
            layer.borderColor = borderColor.cgColor
        }
        clipsToBounds = true
    }
    
}
