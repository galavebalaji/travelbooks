// User.swift
// TraveBook

import Foundation

struct User: Codable {
    
    let userData: UserData?
    
    enum CodingKeys: String, CodingKey {
        
        case userData = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userData = try values.decodeIfPresent(UserData.self, forKey: .userData)
    }

}
