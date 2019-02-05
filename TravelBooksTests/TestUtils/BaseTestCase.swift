//
//  BaseTestCase.swift

import XCTest
@testable import TravelBooks

class BaseTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        configure()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func configure() {
        // Do any dependency injection in this method
    }
}
