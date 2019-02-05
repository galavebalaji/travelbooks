//
//  FetchFeedListService.swift
//  TravelBooks

import Foundation

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
        let params = TravelFeedMapper.getParameters(from: request)
        
        self.getRequest(type: TravelFeedResponse.self,
                        isNeededAccessToken: true,
                        url: url,
                        parameters: params,
                        headers: nil) { travelFeedResponse, _, error, _ in
                            
                            guard let response = travelFeedResponse, error == nil else {
                                completion(.failure(error!))
                                return
                            }
                            completion(.success(response))
        }
    }
    
}
