
import Foundation

struct Attributes: Codable {
    
	let firstName: String?
	let lastName: String?
	let username: String?
	let avatar: String?
	let countriesCount: Int?
	let name: String?

	enum CodingKeys: String, CodingKey {

		case firstName = "first_name"
		case lastName = "last_name"
		case username = "username"
		case avatar = "avatar"
		case countriesCount = "countries_count"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        countriesCount = try values.decodeIfPresent(Int.self, forKey: .countriesCount)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}

}
