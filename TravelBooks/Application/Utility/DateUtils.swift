//
//  DateUtils.swift
//  TravelBooks

import Foundation

struct DateUtils {
    
    //"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static func getDate(from string: String?, format: String) -> Date? {
        
        guard let dateString = string else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: dateString) {
            return date
        }
        return nil
    }
    
}
