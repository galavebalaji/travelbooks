//
//  TravelFeedRequest.swift
//  TravelBooks

import Foundation

enum FeedFilterType {
    case community, friends
}

struct TravelFeedRequest {
    let feedFilterType: FeedFilterType
    let page: Int = 1
}
