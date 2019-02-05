//
//  ViewUtility.swift
//  TravelBooks

import Foundation
import UIKit

struct ViewUtility {
    
    // MARK: StoryBaord Utility Methods
    fileprivate static func getTravelBookStoryBaord() -> UIStoryboard {
        return UIStoryboard(name: "TravelBook", bundle: nil)
    }
    
    // MARK: ViewController Utility Methods
    static func getTravelFeedListViewController() -> TravelFeedListViewController? {
        let storyBoard = getTravelBookStoryBaord()
        let id = "TravelFeedListViewControllerId"
        return storyBoard.instantiateViewController(withIdentifier: id) as? TravelFeedListViewController
    }
    
}
