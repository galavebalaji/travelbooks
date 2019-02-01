//
//  FetchTravelFeedUsecase.swift
//  TravelBooks

import Foundation

typealias FetchFeedCompletion = (Result<[TravelFeedModel]>) -> Void

protocol FetchTravelFeedUsecase {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping FetchFeedCompletion)
}

class FetchTravelFeedUsecaseImpl: FetchTravelFeedUsecase {
    
    private let repository: FetchFeedListRepository
    
    init(repository: FetchFeedListRepository) {
        self.repository = repository
    }
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping FetchFeedCompletion) {
        repository.fetchFeed(with: request) { result in
            
            switch result {
            case .success(let travelResponse):
                let feeds = TravelFeedMapper.getTravelFeedModel(from: travelResponse)
                completion(.success(feeds))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
