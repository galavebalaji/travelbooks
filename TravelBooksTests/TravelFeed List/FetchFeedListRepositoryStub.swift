//
//  FetchFeedListRepositoryStub.swift
//  TravelBooksTests

import Foundation
@testable import TravelBooks

class FetchFeedListRepositoryStub: FetchFeedListRepository {
    
    private let service: FetchFeedListService
    
    init(service: FetchFeedListService) {
        self.service = service
    }
    
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        service.fetchFeed(with: request, completion: completion)
    }
    
}
