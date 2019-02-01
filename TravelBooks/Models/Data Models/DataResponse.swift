
import Foundation

struct DataResponse: Codable {
	let id: Int?
	let type: String?
	let attributes: FeedAttributes?
	let relationships: Relationships?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case type = "type"
		case attributes = "attributes"
		case relationships = "relationships"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		attributes = try values.decodeIfPresent(FeedAttributes.self, forKey: .attributes)
		relationships = try values.decodeIfPresent(Relationships.self, forKey: .relationships)
	}

}
