//
//  CustomButton.swift
//  TravelBooks

import UIKit

class CustomButton: UIButton {

    // Change the stype of border of Friends and Community Sort by buttons
    func changeStyle(isSelected: Bool) {
        let color = isSelected ? UIColor.travelFeedButtonTypeSelected() : UIColor.travelFeedButtonTypeDeselected()
        self.setTitleColor(color, for: .normal)
        
        if isSelected {
            rounded(10, withBorder: true, borderColor: UIColor.travelFeedCellBorder(), borderWidth: 1)
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
