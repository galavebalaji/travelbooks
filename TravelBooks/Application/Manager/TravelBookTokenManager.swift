//
//  TravelBookTokenManager.swift
//  TravelBooks

import Foundation
import Alamofire

class TravelBookTokenManager {
    
    // shared instance to work this class across the app
    static let shared = TravelBookTokenManager()
    
    // Avoid making an instance of this class from outside and to keep it Singleton claas
    private init() {
        
    }
    // private var to hold, save in user defalts and fetch auth token
    private var accessToken: String? {
        set {
            KeychainManager.saveAccessToken(token: NSString(string: newValue ?? ""))
        }
        get {
            if let token = KeychainManager.getAccessToken() as String? {
                return token
            }
            return nil
        }
    }
    
    // check method if we have accesstoken
    func hasAccessToken() -> Bool {
        if let token = self.accessToken {
            return !token.isEmpty
        }
        return false
    }
    
    // get access token through shared instace
    func getAccessToken() -> String? {
        return accessToken
    }
    
    private func setAccessToken(token: String) {
        accessToken = token
    }
}

extension TravelBookTokenManager {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    class OAuth2Handler: RequestAdapter, RequestRetrier {
        
        private let sessionManager: SessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            
            return SessionManager(configuration: configuration)
        }()
        
        private let lock = NSLock()
        
        private var clientID: String
        private var clientSecret: String
        private var userEmailId: String
        private var password: String
        private var baseURLString: String
        
        private var isRefreshing = false
        private var requestsToRetry: [RequestRetryCompletion] = []
        
        private var grantType = "password"
        
        // MARK: - Initialization
        
        public init(clientID: String, clientSecret: String, userEmailId: String, password: String, baseURLString: String) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.userEmailId = userEmailId
            self.password = password
            self.baseURLString = baseURLString
        }
        
        // MARK: - RequestAdapter
        
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
                var request = urlRequest
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                if let token = TravelBookTokenManager.shared.getAccessToken() {
                    let string = "access_token=\(token)"
                    request.httpBody = string.data(using: .utf8)
                }
                return request
            }
            
            return urlRequest
        }
        
        // MARK: - RequestRetrier
        
        func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
            lock.lock() ; defer { lock.unlock() }
            
            if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
                requestsToRetry.append(completion)
                
                if !isRefreshing {
                    refreshTokens { [weak self] succeeded, accessToken in
                        guard let strongSelf = self else { return }
                        
                        strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                        
                        if let accessToken = accessToken {
                            TravelBookTokenManager.shared.setAccessToken(token: accessToken)
                        }
                        
                        strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                        strongSelf.requestsToRetry.removeAll()
                    }
                }
            } else {
                completion(false, 0.0)
            }
        }
        
        // MARK: - Private - Refresh Tokens
        
        private func refreshTokens(completion: @escaping RefreshCompletion) {
            guard !isRefreshing else { return }
            
            isRefreshing = true
            
            let urlString = "\(baseURLString)/token"
            
            let parameters: [String: Any] = ["client_id": clientID,
                                             "client_secret": clientSecret,
                                             "grant_type": grantType,
                                             "email": userEmailId,
                                             "password": password
            ]
            
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            sessionManager.request(urlString, method: .post, parameters: parameters, headers: headers)
                .responseJSON { [weak self] response in
                    guard let strongSelf = self else { return }
                    
                    if
                        let json = response.result.value as? [String: Any],
                        let accessToken = json["access_token"] as? String
                    {
                        completion(true, accessToken)
                    } else {
                        completion(false, nil)
                    }
                    
                    strongSelf.isRefreshing = false
            }
        }
    }
    
}
