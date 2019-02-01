//
//  UserData.swift

import Foundation

struct UserData: Codable {
    
    let id: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}
