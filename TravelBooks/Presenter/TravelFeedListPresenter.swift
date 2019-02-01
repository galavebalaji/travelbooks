//
//  TravelFeedListPresenter.swift
//  TravelBooks

import Foundation

protocol TravelFeedListPresenterInput {
    func fetchFeedList()
}

protocol TravelFeedListPresenterOutput: AnyObject {
    
}

class TravelFeedListPresenter: TravelFeedListPresenterInput {
    
    private let fetchTravelFeedUsecase: FetchTravelFeedUsecase
    weak var travelFeedListPresenterOutput: TravelFeedListPresenterOutput?
    
    init(fetchTravelFeedUsecase: FetchTravelFeedUsecase, travelFeedListPresenterOutput: TravelFeedListPresenterOutput?) {
        self.fetchTravelFeedUsecase = fetchTravelFeedUsecase
        self.travelFeedListPresenterOutput = travelFeedListPresenterOutput
    }
    
    func fetchFeedList() {
        fetchTravelFeedUsecase.fetchFeed(with: TravelFeedRequest(feedFilterType: .community, page: 1)) { result in
            switch result {
            case .success(let feeds):
                Logger.log(message: "Feeds = \(feeds.count)", messageType: .debug)
            case .failure(_):
                break
            }
        }
    }
}
