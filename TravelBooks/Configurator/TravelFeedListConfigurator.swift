//
//  TravelFeedListConfigurator.swift
//  TravelBooks

import Foundation

protocol TravelFeedListConfigurator {
    func configure(travelFeedListViewController: TravelFeedListViewController)
}

class TravelFeedListConfiguratorImpl: TravelFeedListConfigurator {
    
    func configure(travelFeedListViewController: TravelFeedListViewController) {
        
        let service = FetchFeedListServiceImpl()
        let repository = FetchFeedListRepositoryImpl(service: service)
        let usecase = FetchTravelFeedUsecaseImpl(repository: repository)
        let presenter = TravelFeedListPresenter(fetchTravelFeedUsecase: usecase,
                                                travelFeedListPresenterOutput: travelFeedListViewController)
        travelFeedListViewController.presenter = presenter
    }
    
}
