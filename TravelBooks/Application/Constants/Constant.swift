//
//  Constant.swift
//  TravelBooks

import Foundation

struct APIUrlsConstant {
    //https://staging.travelbook.com/api/v1/feeds?access_token=c681ecad81a93030e201b6bef91ae1f0f3c36b0bdf39d1402b8c24954f6cc2ef&page=1&filter[scope]=community"
    private static let BASEURL = "https://staging.travelbook.com"
    private static let apiVersion = "/api/v1/"
    
    struct TravelFeed {
        private static let feedPoint = "feeds"
        static let url = APIUrlsConstant.BASEURL + APIUrlsConstant.apiVersion + feedPoint
    }
    
}

struct Constant {
    struct TravelFeedListConstants {
        static let travelFeedTableCellId = "TravelFeedTableViewCellId"
        static let travelFeedTableCellName = "TravelFeedTableViewCell"
    }
}

