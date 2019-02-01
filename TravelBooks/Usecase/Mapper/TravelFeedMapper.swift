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
                    
                    //let currentDate = feed.attributes?.publishedAt?.toDate?.currentDate
                    
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
        params["access_token"] = "c681ecad81a93030e201b6bef91ae1f0f3c36b0bdf39d1402b8c24954f6cc2ef"
        
        return params
    }
    
}
