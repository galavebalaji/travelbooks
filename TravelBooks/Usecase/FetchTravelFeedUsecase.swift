//
//  FetchTravelFeedUsecase.swift
//  TravelBooks

import Foundation

typealias FetchFeedCompletion = (APIResult<[TravelFeedModel]>) -> Void

// This is boundary protocol for the communication purpose
protocol FetchTravelFeedUsecase {
    func fetchFeed(with request: TravelFeedRequest, completion: @escaping FetchFeedCompletion)
}

class FetchTravelFeedUsecaseImpl: FetchTravelFeedUsecase {
    
    private let repository: FetchFeedListRepository
    
    init(repository: FetchFeedListRepository) {
        self.repository = repository
    }
    
    // Usecase call repository to fetch the data
    // then once usecase receives the data, it converts into UI model by calling mapper and returns to the Presenter with completion handler
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
