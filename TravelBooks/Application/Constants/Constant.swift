//
//  Constant.swift
//  TravelBooks

import Foundation
import UIKit

struct APIUrlsConstant {
    //https://staging.travelbook.com/api/v1/feeds?access_token=c681ecad81a93030e201b6bef91ae1f0f3c36b0bdf39d1402b8c24954f6cc2ef&page=1&filter[scope]=community"
    //https://travelbook.com/api/v1/feeds.json
    private static let BASEURL = "https://travelbook.com"
    private static let apiVersion = "/api/v1/"
    
    struct TravelFeed {
        private static let feedPoint = "feeds.json"
        static let url = APIUrlsConstant.BASEURL + APIUrlsConstant.apiVersion + feedPoint
    }
    
}

struct Constant {
    struct TravelFeedListConstants {
        static let travelFeedTableCellId = "TravelFeedTableViewCellId"
        static let travelFeedTableCellName = "TravelFeedTableViewCell"
    }
    
    struct Dimension {
        static let iOSPOINTS0: CGFloat = 0
        static let iOSPOINTS20: CGFloat = 20
        static let iOSPOINTS8: CGFloat = 8
        static let iOSPOINTS16: CGFloat = 16
    }
}
