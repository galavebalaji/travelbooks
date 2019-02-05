//
//  TravelFeedModel.swift
//  TravelBooks

import Foundation

// This holds one information of feed
struct TravelFeedModel {
    let userInformation: UserInformation?
    let urlCoverImage: String?
    let publishedDate: Date?
}

// Holds User related information
struct UserInformation {
    let id: String?
    let userFirstName: String?
    let userLastName: String?
    let urlUserAvatar: String?
}
