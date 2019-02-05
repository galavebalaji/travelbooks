//
//  UserData.swift

import Foundation

struct UserData: Codable {
    
    let id: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case type
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}
