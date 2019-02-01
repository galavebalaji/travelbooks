//
//  BaseService.swift

import Foundation
import Alamofire

class BaseService: SessionDelegate {
    
    private var requestManager: SessionManager?
    private var dataRequest: DataRequest?
    
    override init() {
        
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        requestManager = SessionManager(configuration: configuration, delegate: self, serverTrustPolicyManager: nil)
    }
    
    private func cancelRequest() {
        dataRequest?.cancel()
    }
    
}


