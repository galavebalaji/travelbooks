//
//  TravelFeedRequest.swift
//  TravelBooks

import Foundation

enum FeedFilterType {
    case community, friends
}

struct TravelFeedRequest {
    let feedFilterType: FeedFilterType
    var page: Int = 1
    
    init(feedFilterType: FeedFilterType, page: Int) {
        self.feedFilterType = feedFilterType
        self.page = page
    }
}
