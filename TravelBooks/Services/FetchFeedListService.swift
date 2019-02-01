//
//  FetchFeedListService.swift
//  TravelBooks

import Foundation

protocol FetchFeedListService {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion)
}

class FetchFeedListServiceImpl: BaseService {
    
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping TravelFeedsCompletion) {
        
    }
}
