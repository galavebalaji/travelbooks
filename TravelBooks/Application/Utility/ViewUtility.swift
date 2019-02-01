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
    static func getTravelBookListViewController() -> TravelBookListViewController? {
        return getTravelBookStoryBaord().instantiateViewController(withIdentifier: "TravelBookListViewControllerId") as? TravelBookListViewController
    }
    
}
