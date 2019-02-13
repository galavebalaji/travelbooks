//
//  TravelFeedResponse.swift
//  TravelBooks

import Foundation

// As Base data layer model
struct TravelFeedResponse: Codable {
    
	var data = [DataResponse]()
	var included = [Included]()
	let links: Links?

    enum CodingKeys: String, CodingKey {

        case data
        case included
        case links
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([DataResponse].self, forKey: .data) ?? [DataResponse]()
        included = try values.decodeIfPresent([Included].self, forKey: .included) ?? [Included]()
        links = try values.decodeIfPresent(Links.self, forKey: .links)
    }

}
