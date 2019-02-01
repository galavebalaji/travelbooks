//
//  FetchFeedListRepository.swift
//  TravelBooks

import Foundation

typealias TravelFeedsCompletion = (Result<TravelFeedResponse>) -> Void

protocol FetchFeedListRepository {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion)
}

class FetchFeedListRepositoryImpl: FetchFeedListRepository {
    
    private let service: FetchFeedListService
    
    init(service: FetchFeedListService) {
        self.service = service
    }
    
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        service.fetchFeed(with: request, completion: completion)
    }
}
