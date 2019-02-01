//
//  String+Extension.swift
//  TravelBooks

import Foundation

extension String {
    
    var toDate: Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        return nil
    }
    
}
