// Included.swift
// TravelBook

import Foundation

struct Included: Codable {
	let id: String?
	let type: String?
	let attributes: Attributes?

	enum CodingKeys: String, CodingKey {

		case id
		case type
		case attributes
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		attributes = try values.decodeIfPresent(Attributes.self, forKey: .attributes)
	}

}
