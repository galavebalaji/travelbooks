
import Foundation

struct Relationships: Codable {
	let user: User?
	let destination: Destination?

	enum CodingKeys: String, CodingKey {

		case user
		case destination
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		user = try values.decodeIfPresent(User.self, forKey: .user)
		destination = try values.decodeIfPresent(Destination.self, forKey: .destination)
	}

}
