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
                    let date = feed.attributes?.publishedAt?.toDate
                    travelFeedModel.append(TravelFeedModel(userInformation: userInfo,
                                                            urlCoverImage: feed.attributes?.coverImageUrl,
                                                            publishedDate: date))
                }
            }
        }
        return travelFeedModel
    }
    
    static private func getUserInformation(for userId: String, from includes: [Included]) -> UserInformation? {
        
        guard !includes.isEmpty else {
            return nil
        }
        
        let userInclude = includes.first { include -> Bool in
            if let id = include.id {
                return id == userId
            }
            return false
        }
        
        if let user = userInclude {
            return UserInformation(id: user.id,
                                   userFirstName: user.attributes?.firstName,
                                   userLastName: user.attributes?.lastName,
                                   urlUserAvatar: user.attributes?.avatar)
        }
        return nil
    }
    
    static func getParameters(from request: TravelFeedRequest) -> [String: Any] {
        
        var params = [String: Any]()
        
        switch request.feedFilterType {
        case .community:
            params["filter[scope]"] = "community"
        case .friends:
            params["filter[scope]"] = "friends"
        }
        
        params["page"] = request.page
        params["access_token"] = "2ca3481d00d50390df42e9490b504707f277b6665e8b2725c8f92e8bc6e8e46b"
        
        return params
    }
    
}
