//
//  TravelFeedResponse.swift
//  TravelBooks

import Foundation

// As Base data layer model
struct TravelFeedResponse: Codable {
    
	let data: [DataResponse]?
	let included: [Included]?
	let links: Links?

	enum CodingKeys: String, CodingKey {

		case data
		case included
		case links
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([DataResponse].self, forKey: .data)
		included = try values.decodeIfPresent([Included].self, forKey: .included)
		links = try values.decodeIfPresent(Links.self, forKey: .links)
	}

}
