//
//  FeedAttributes.swift
//  TravelBooks

import Foundation

import Foundation

struct FeedAttributes: Codable {
    
    let startDate: String?
    let likesCount: Int = 0
    let commentsCount: Int = 0
    let privacy: String?
    let createdAt: String?
    let updatedAt: String?
    let publishedAt: String?
    var isNew: Bool = false
    let coverImageUrl: String?
    let mediaCount: Int = 0
    let slug: String?
    var isPublished: Bool = false
    
}
