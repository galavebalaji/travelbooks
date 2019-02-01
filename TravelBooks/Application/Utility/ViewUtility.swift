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
        return getTravelBookStoryBaord().instantiateViewController(withIdentifier: "TravelFeedListViewControllerId") as? TravelFeedListViewController
    }
    
}
