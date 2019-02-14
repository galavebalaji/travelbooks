//
//  FetchFeedListServiceStub.swift
//  TravelBooksTests

import Foundation
@testable import TravelBooks

class FetchFeedListServiceStub: FetchFeedListService {
    
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        
        let generator = StubGenerator()
        
        do {
            
            if let data = generator.getFeedData() {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseModel = try jsonDecoder.decode(TravelFeedResponse.self, from: data)
                completion(.success(responseModel))
            }
            
        } catch let error {
            completion(.failure(error))
        }
    }
}
