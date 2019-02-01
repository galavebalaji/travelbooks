//
//  FeedAttributes.swift
//  TravelBooks

import Foundation

import Foundation

struct FeedAttributes: Codable {
    
    let startDate: String?
    let likesCount: Int?
    let commentsCount: Int?
    let privacy: String?
    let createdAt: String?
    let updatedAt: String?
    let publishedAt: String?
    var isNew: Bool = false
    let coverImageUrl: String?
    let mediaCount: Int?
    let slug: String?
    var isPublished: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        case startDate = "start_date"
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case privacy = "privacy"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case isNew = "is_new"
        case coverImageUrl = "cover_image_url"
        case mediaCount = "media_count"
        case slug = "slug"
        case isPublished = "is_published"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount)
        commentsCount = try values.decodeIfPresent(Int.self, forKey: .commentsCount)
        privacy = try values.decodeIfPresent(String.self, forKey: .privacy)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        publishedAt = try values.decodeIfPresent(String.self, forKey: .publishedAt)
        isNew = try values.decodeIfPresent(Bool.self, forKey: .isNew) ?? false
        coverImageUrl = try values.decodeIfPresent(String.self, forKey: .coverImageUrl)
        mediaCount = try values.decodeIfPresent(Int.self, forKey: .mediaCount)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        isPublished = try values.decodeIfPresent(Bool.self, forKey: .isPublished) ?? false
    }
    
}
