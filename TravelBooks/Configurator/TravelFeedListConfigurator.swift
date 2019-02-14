//
//  TravelFeedListConfigurator.swift
//  TravelBooks

import Foundation

protocol TravelFeedListConfigurator {
    func configure(travelFeedListViewController: TravelFeedListViewController)
}

class TravelFeedListConfiguratorImpl: TravelFeedListConfigurator {
    
    // Configures the all classes just like injecting
    func configure(travelFeedListViewController: TravelFeedListViewController) {
        
        let service = FetchFeedListServiceImpl()
        let usecase = FetchTravelFeedUsecaseImpl(service: service)
        let presenter = TravelFeedListPresenter(fetchTravelFeedUsecase: usecase,
                                                travelFeedListPresenterOutput: travelFeedListViewController)
        travelFeedListViewController.presenter = presenter
    }
    
}
