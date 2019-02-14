//
//  FetchFeedListService.swift
//  TravelBooks

import Foundation

typealias TravelFeedsCompletion = (APIResult<TravelFeedResponse>) -> Void

protocol FetchFeedListService {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion)
}

// This is to fetch feed list service
// Calls to the BaseService method and sends back to the repository
class FetchFeedListServiceImpl: BaseService, FetchFeedListService {
    
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        
        guard let url = URL(string: APIUrlsConstant.TravelFeed.url) else {
            completion(.failure(NSError(domain: "com.travelbook.feed", code: 45454, userInfo: nil) as Error))
            return
        }
        
        // Get parameters from request model
        let params = TravelFeedMapper.getParameters(from: request)
        
        self.loadData(type: TravelFeedResponse.self,
                      url: url,
                      method: .get,
                      parameters: params) { travelFeedResponse, error, data in
            guard let response = travelFeedResponse, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(response))
        }
    }
    
}
