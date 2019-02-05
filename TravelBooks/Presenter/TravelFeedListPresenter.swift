//
//  TravelFeedListPresenter.swift
//  TravelBooks

import Foundation

// Defines methods to be called from viewcontroller
protocol TravelFeedListPresenterInput {
    var hasMoreFeeds: Bool { get set }
    var numberOfFeeds: Int { get }
    func fetchFeedList(for type: FeedFilterType, page: Int)
    func numberOfRows(for section: Int) -> Int
    func travelModel(for index: Int) -> TravelFeedModel?
    func resetTravelFeedList()
}

// Defines the methods to call on viewcontroller
protocol TravelFeedListPresenterOutput: AnyObject {
    func reloadData()
    func stopPullToRefreshIndicator()
    func showLoader(shouldShow: Bool)
}

class TravelFeedListPresenter: TravelFeedListPresenterInput {
    
    private let fetchTravelFeedUsecase: FetchTravelFeedUsecase
    
    // Holds reference back to the view controller
    private weak var travelFeedListPresenterOutput: TravelFeedListPresenterOutput?
    
    private var travelFeedList = [TravelFeedModel]()
    
    // return totoal number of feeds
    var numberOfFeeds: Int {
        return travelFeedList.count
    }
    
    // this is to keep track if there is not page ahead
    // as of now we dont understand how to check from API response, so just it will be true forever
    var hasMoreFeeds: Bool = true
    
    init(fetchTravelFeedUsecase: FetchTravelFeedUsecase, travelFeedListPresenterOutput: TravelFeedListPresenterOutput?) {
        self.fetchTravelFeedUsecase = fetchTravelFeedUsecase
        self.travelFeedListPresenterOutput = travelFeedListPresenterOutput
    }
    
    // This calls to the usecase to provide data from API
    func fetchFeedList(for type: FeedFilterType, page: Int) {
        
        guard hasMoreFeeds else {
            return
        }
        // Show Loader if page is first otherwise for other pages dont show it.
        // just for good user experience
        travelFeedListPresenterOutput?.showLoader(shouldShow: page == 1)
        
        // Call Usecse asynchronously to fetch the data
        fetchTravelFeedUsecase.fetchFeed(with: TravelFeedRequest(feedFilterType: .community,
                                                                 page: page)) { [weak self] result in
                                                                    
            self?.travelFeedListPresenterOutput?.showLoader(shouldShow: false)
                       
            switch result {
                
            case .success(let newFeeds):
                Logger.log(message: " All fetched feeds = \(newFeeds.count)", messageType: .debug)
                if page == 1 {
                    
                    self?.travelFeedListPresenterOutput?.stopPullToRefreshIndicator()
                    self?.travelFeedList = newFeeds
                    
                } else {
                    
                    self?.travelFeedList.append(contentsOf: newFeeds)
                }
                
                self?.travelFeedListPresenterOutput?.reloadData()
            case .failure(_):
                
                if page == 1 {
                    self?.travelFeedListPresenterOutput?.stopPullToRefreshIndicator()
                }
                
            }
        }
    }
    
    // returns the total number of rows for a particular section
    func numberOfRows(for section: Int) -> Int {
        return travelFeedList.count
    }
    
    // Returns the travel feed model for a row
    func travelModel(for index: Int) -> TravelFeedModel? {
        if !travelFeedList.isEmpty, travelFeedList.count > index {
            return travelFeedList[index]
        }
        return nil
    }
    
    // removed all travel feed list when you choose different filter
    func resetTravelFeedList() {
        travelFeedList.removeAll()
    }
}
