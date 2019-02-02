//
//  CustomButton.swift
//  TravelBooks

import UIKit

class CustomButton: UIButton {

    func changeStyle(isSelected: Bool) {
        let color = isSelected ? UIColor.travelFeedButtonTypeSelected() : UIColor.travelFeedButtonTypeDeselected()
        self.setTitleColor(color, for: .normal)
        
        if isSelected {
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 10
            self.layer.borderColor = UIColor.travelFeedCellBorder().cgColor
            self.clipsToBounds = true
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
