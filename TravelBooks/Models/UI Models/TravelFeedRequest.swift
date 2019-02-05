//
//  TravelFeedRequest.swift
//  TravelBooks

import Foundation

// This defines the sorting type.
// As of now we only have two type i.e. friends and community
enum FeedFilterType {
    case community, friends
}

// This is UI Request model which holds sorting type that user has selected and requested current page
struct TravelFeedRequest {
    let feedFilterType: FeedFilterType
    var page: Int = 1
    
    init(feedFilterType: FeedFilterType, page: Int) {
        self.feedFilterType = feedFilterType
        self.page = page
    }
}
