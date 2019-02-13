//
//  BaseService.swift

import Foundation
import Alamofire

/*
 All API request shall go through this service
 This is just a bottleneck for all API requests in a App
 All service classes must inherite this to take an adantages
 */

class BaseService: SessionDelegate {
    
    // Define the alamofire session manager
    private var requestManager: SessionManager?
    
    // defines data request
    private var dataRequest: DataRequest?
    
    private let accessTokenKey = "access_token"
    
    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        requestManager = SessionManager(configuration: configuration, delegate: self, serverTrustPolicyManager: nil)
    }
    
    // Each inherited service should call this method for GET method only
    // This check if this service needs a accessToken and based on that it fetches
    func getRequest<T: Decodable>(type model: T.Type,
                                  isNeededAccessToken: Bool,
                                  url: URL,
                                  parameters: [String: Any]?,
                                  headers: [String: String]? = nil,
                                  completion:@escaping (T?, _ json: Any?, _ error: Error?, _ data: Data?) -> Void) {
        // if access token needed for this url then first get and load the request
        if isNeededAccessToken {
            // check if access token is there, else fetch it from OAuth
            if TravelBookTokenManager.shared.hasAccessToken(),
                let token = TravelBookTokenManager.shared.getAccessToken() {
                
                var params = parameters
                params?[accessTokenKey] = token
                
                loadData(type: T.self, url: url, parameters: params, headers: headers, completion: completion)
                
            } else {
                // start process of getting access token
                TravelBookTokenManager.shared.startAuthentication { [weak self] accessToken, error in
                    
                    if let token = accessToken, error == nil {
                        
                        var params = parameters
                        params?[self?.accessTokenKey ?? ""] = token
                        
                        self?.loadData(type: T.self,
                                       url: url,
                                       parameters: params,
                                       headers: headers,
                                       completion: completion)
                    } else {
                        completion(nil, nil, error, nil)
                    }
                }
            }
        } else {
            loadData(type: T.self, url: url, parameters: parameters, headers: headers, completion: completion)
        }
    }
    
    // loads data from URL
    final private func loadData<T: Decodable>(type model: T.Type,
                                              url: URL,
                                              parameters: [String: Any]?,
                                              headers: [String: String]? = nil,
                                              completion:@escaping (T?, _ json: Any?, _ error: Error?, _ data: Data?) -> Void) {
        
        dataRequest = requestManager?.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { responseJson in
                
                Logger.log(message: "GET " + (responseJson.request?.url?.absoluteString ?? ""), messageType: .debug)
                
                do {
                    guard let data = responseJson.data, responseJson.result.error == nil
                        else {
                            Logger.log(message: "Error", messageType: .error)
                            completion(nil, nil, responseJson.result.error, nil)
                            return
                    }
                    
                    if let json = responseJson.result.value as? [String: Any?] {
                        Logger.log(message: json.description, messageType: .debug)
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    
                    completion(responseModel, responseJson.result.value, responseJson.result.error, data)
                    
                }catch let error {
                    Logger.log(message: error.localizedDescription, messageType: .error)
                    completion(nil, error as NSError, nil, nil)
                }
        }
    }
    
    private func cancelRequest() {
        dataRequest?.cancel()
    }
    
}
