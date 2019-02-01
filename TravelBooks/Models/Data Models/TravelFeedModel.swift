//
//  TravelFeedModel.swift
//  TravelBooks

import Foundation

struct TravelFeedModel {
    let userInformation: UserInformation?
    let urlCoverImage: String?
    let publishedDate: Date?
}

struct UserInformation {
    let id: Int?
    let userFirstName: String?
    let userLastName: String?
    let urlUserAvatar: String?
}
