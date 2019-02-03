//
//  TravelFeedListPresenter.swift
//  TravelBooks

import Foundation

protocol TravelFeedListPresenterInput {
    func fetchFeedList(for type: FeedFilterType)
    func numberOfRows(for section: Int) -> Int
    func travelModel(for index: Int) -> TravelFeedModel?
}

protocol TravelFeedListPresenterOutput: AnyObject {
    func reloadData()
}

class TravelFeedListPresenter: TravelFeedListPresenterInput {
    
    private let fetchTravelFeedUsecase: FetchTravelFeedUsecase
    weak var travelFeedListPresenterOutput: TravelFeedListPresenterOutput?
    
    private var travelFeedList = [TravelFeedModel]()
    
    init(fetchTravelFeedUsecase: FetchTravelFeedUsecase, travelFeedListPresenterOutput: TravelFeedListPresenterOutput?) {
        self.fetchTravelFeedUsecase = fetchTravelFeedUsecase
        self.travelFeedListPresenterOutput = travelFeedListPresenterOutput
    }
    
    func fetchFeedList(for type: FeedFilterType) {
        fetchTravelFeedUsecase.fetchFeed(with: TravelFeedRequest(feedFilterType: .community, page: 1)) { [weak self] result in
            switch result {
            case .success(let feeds):
                Logger.log(message: "Feeds = \(feeds.count)", messageType: .debug)
                self?.travelFeedList = feeds
                
                self?.travelFeedListPresenterOutput?.reloadData()
                
            case .failure(_):
                break
            }
        }
    }
    
    func numberOfRows(for section: Int) -> Int {
        return travelFeedList.count
    }
    
    func travelModel(for index: Int) -> TravelFeedModel? {
        if !travelFeedList.isEmpty, travelFeedList.count > index {
            return travelFeedList[index]
        }
        return nil
    }
}
