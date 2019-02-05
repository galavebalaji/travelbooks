// Links.swift
// TravelBook

import Foundation

struct Links: Codable {
	let next: String?
	let last: String?

	enum CodingKeys: String, CodingKey {

		case next
		case last
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		next = try values.decodeIfPresent(String.self, forKey: .next)
		last = try values.decodeIfPresent(String.self, forKey: .last)
	}

}
