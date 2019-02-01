//
//  TravelFeedMapper.swift
//  TravelBooks

import Foundation

struct TravelFeedMapper {
    
    static func getTravelFeedModel(from response: TravelFeedResponse) -> [TravelFeedModel] {
        
        var travelFeedModel = [TravelFeedModel]()
        
        if let allFeeds = response.data, !allFeeds.isEmpty,
            let allUsersOrPlaces = response.included,
            !allUsersOrPlaces.isEmpty {
            
            let userIncludes = allUsersOrPlaces.filter { $0.type == "users" }
            
            for feed in allFeeds {
                if let userId = feed.relationships?.user?.userData?.id,
                    let userInfo = getUserInformation(for: userId, from: userIncludes) {
                    travelFeedModel.append(TravelFeedModel(userInformation: userInfo,
                                                            urlCoverImage: feed.attributes?.coverImageUrl,
                                                            publishedDate: DateUtils.getDate(from: feed.attributes?.publishedAt,
                                                            format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")))
                }
            }
            
        }
        
        return travelFeedModel
    }
    
    static private func getUserInformation(for userId: Int, from includes: [Included]) -> UserInformation? {
        
        guard !includes.isEmpty else {
            return nil
        }
        
        let userInclude = includes.first { (include) -> Bool in
            if let id = include.id {
                return id == userId
            }
            return false
        }
        
        if let user =  userInclude {
            return UserInformation(id: user.id, userFirstName: user.attributes?.firstName, userLastName: user.attributes?.lastName,urlUserAvatar: user.attributes?.avatar)
        }
        return nil
    }
    
}
