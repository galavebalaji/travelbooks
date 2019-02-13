//
//  FetchFeedListRepository.swift
//  TravelBooks

import Foundation

// type alias to hold the type and reusability
typealias TravelFeedsCompletion = (APIResult<TravelFeedResponse>) -> Void

// This is boundary protocol for the communication purpose
protocol FetchFeedListRepository {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion)
}

class FetchFeedListRepositoryImpl: FetchFeedListRepository {
    
    private let service: FetchFeedListService
    
    init(service: FetchFeedListService) {
        self.service = service
    }
    
    // Calls to service and sends data back to the usecase
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        service.fetchFeed(with: request, completion: completion)
    }
}
