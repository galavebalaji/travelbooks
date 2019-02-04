//
//  TravelFeedListPresenter.swift
//  TravelBooks

import Foundation

protocol TravelFeedListPresenterInput {
    var hasMoreFeeds: Bool { get set }
    var numberOfFeeds: Int { get }
    func fetchFeedList(for type: FeedFilterType, page: Int)
    func numberOfRows(for section: Int) -> Int
    func travelModel(for index: Int) -> TravelFeedModel?
    func resetTravelFeedList()
}

protocol TravelFeedListPresenterOutput: AnyObject {
    func reloadData()
    func stopPullToRefreshIndicator()
    func showLoader(shouldShow: Bool)
}

class TravelFeedListPresenter: TravelFeedListPresenterInput {
    
    private let fetchTravelFeedUsecase: FetchTravelFeedUsecase
    weak var travelFeedListPresenterOutput: TravelFeedListPresenterOutput?
    
    private var travelFeedList = [TravelFeedModel]()
    
    var numberOfFeeds: Int {
        return travelFeedList.count
    }
    
    var hasMoreFeeds: Bool = true
    
    init(fetchTravelFeedUsecase: FetchTravelFeedUsecase, travelFeedListPresenterOutput: TravelFeedListPresenterOutput?) {
        self.fetchTravelFeedUsecase = fetchTravelFeedUsecase
        self.travelFeedListPresenterOutput = travelFeedListPresenterOutput
    }
    
    func fetchFeedList(for type: FeedFilterType, page: Int) {
        guard hasMoreFeeds else {
            return
        }
        travelFeedListPresenterOutput?.showLoader(shouldShow: page == 1)
        fetchTravelFeedUsecase.fetchFeed(with: TravelFeedRequest(feedFilterType: type,
                                                                 page: page)) { [weak self] result in
            self?.travelFeedListPresenterOutput?.showLoader(shouldShow: false)
            switch result {
            case .success(let newFeeds):
                Logger.log(message: "Feeds = \(newFeeds.count)", messageType: .debug)
                if page == 1 {
                    self?.travelFeedListPresenterOutput?.stopPullToRefreshIndicator()
                    self?.travelFeedList = newFeeds
                } else {
                    self?.travelFeedList.append(contentsOf: newFeeds)
                }
                
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
    
    func resetTravelFeedList() {
        travelFeedList.removeAll()
    }
}
