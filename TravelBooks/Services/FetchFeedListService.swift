//
//  FetchFeedListService.swift
//  TravelBooks

import Foundation

protocol FetchFeedListService {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion)
}

class FetchFeedListServiceImpl: BaseService, FetchFeedListService {
    
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        
        guard let url = URL(string: APIUrlsConstant.TravelFeed.url) else {
            completion(.failure(NSError(domain: "com.travelbook.feed", code: 45454, userInfo: nil) as Error))
            return
        }
        let params = TravelFeedMapper.getParameters(from: request)
        self.getRequest(type: TravelFeedResponse.self,
                        url: url, parameters: params) { (travelFeedResponse, json, error, data) in
            
            guard let response = travelFeedResponse, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(response))
        }
    }
}
