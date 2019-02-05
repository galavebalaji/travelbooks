//
//  FetchTravelFeedUsecaseTest.swift
//  TravelBooksTests

import XCTest
@testable import TravelBooks

class FetchTravelFeedUsecaseTest: BaseTestCase {
    
    var fetchTravelFeedUsecase: FetchTravelFeedUsecase?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // This method is called automatically from base test case setup method
    override func configure() {
        super.configure()
        
        let service = FetchFeedListServiceImpl()
        let repository = FetchFeedListRepositoryImpl(service: service)
        fetchTravelFeedUsecase = FetchTravelFeedUsecaseImpl(repository: repository)
    }
    
    func testFetchFeedListCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = XCTestExpectation(description: "Feed list count must be equal to 25")
        let request = TravelFeedRequest(feedFilterType: .community, page: 1)
        
        fetchTravelFeedUsecase?.fetchFeed(with: request) { result in
            switch result {
            case .success(let feedModels):
                
                XCTAssert(feedModels.count == 25, "Test passed")
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("Error occured \(error)")
            }
        }
        wait(for: [expectation], timeout: 20)
    }
    
}
