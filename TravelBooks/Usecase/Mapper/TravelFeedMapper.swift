//
//  TravelFeedMapper.swift
//  TravelBooks

import Foundation

/*
 Contains business logic for mapping values from Data/Response models to UI Models
 */

struct TravelFeedMapper {
    
    // Convert TravelFeedResponse to array of TravelFeedModel
    static func getTravelFeedModel(from response: TravelFeedResponse) -> [TravelFeedModel] {
        
        var travelFeedModel = [TravelFeedModel]()
        
        let allUsersOrPlaces = response.included
        let allFeeds = response.data
        
        if !allFeeds.isEmpty,
            !allUsersOrPlaces.isEmpty {
            
            let userIncludes = allUsersOrPlaces.filter { $0.type == "users" }
            
            for feed in allFeeds {
                if let userId = feed.relationships?.user?.data?.id,
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
    
    // Finds the user information from includes
    static private func getUserInformation(for userId: String, from includes: [Included]) -> UserInformation? {
        
        guard !includes.isEmpty else {
            return nil
        }
        
        let userInclude = includes.first { include -> Bool in
                return include.id == userId
        }
        
        if let user = userInclude {
            return UserInformation(id: user.id,
                                   userFirstName: user.attributes?.firstName,
                                   userLastName: user.attributes?.lastName,
                                   urlUserAvatar: user.attributes?.avatar)
        }
        return nil
    }
    
    // Converts UI request model to parameter dictionary needed for API
    static func getParameters(from request: TravelFeedRequest) -> [String: Any] {
        
        var params = [String: Any]()
        
        switch request.feedFilterType {
        case .community:
            params["filter[scope]"] = "community"
        case .friends:
            params["filter[scope]"] = "friends"
        }
        
        params["page"] = request.page
        
        return params
    }
    
}
