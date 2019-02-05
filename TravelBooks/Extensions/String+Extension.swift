//
//  String+Extension.swift
//  TravelBooks

import Foundation

extension String {
    
    // Converts the string to date format for specific date format in Feeds list response
    var toDate: Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
    
    // Localizes the givem
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
