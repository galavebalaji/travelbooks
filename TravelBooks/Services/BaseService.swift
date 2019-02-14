//
//  BaseService.swift

import Foundation
import Alamofire

typealias APIResult = Result

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
    
    typealias ResponseCompletion<T: Decodable> = (T?, _ error: Error?, _ data: Data?) -> Void
    
    private var clientId = "3bb0640f3232379a9e07c0c44f9ef5e764eefb9ba0e1d31168a90ecebe2bc67d"
    private var clientSecret = "073177b5f4f3489d46921c62629a42aa7b2bbdf57fc578bf2c61917957d037cc"
    private var grantType = "password"
    private var userEmailId = "olivier@nimbl3.com"
    private var password = "12345678"
    
    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        requestManager = SessionManager(configuration: configuration, delegate: self, serverTrustPolicyManager: nil)
        
        // Configure Auth handler to retry requests automatically if token was expired/empty
        let oauthHandler = TravelBookTokenManager.OAuth2Handler(clientID: clientId,
                                                                clientSecret: clientSecret,
                                                                userEmailId: userEmailId,
                                                                password: password,
                                                                baseURLString: APIUrlsConstant.baseUrlAndApiVersion)
        requestManager?.adapter = oauthHandler
        requestManager?.retrier = oauthHandler
    }
    
    // loads data from URL
    final func loadData<T: Decodable>(type model: T.Type,
                                      url: URL,
                                      method: HTTPMethod,
                                      parameters: [String: Any]?,
                                      headers: [String: String]? = nil,
                                      completion:@escaping ResponseCompletion<T>) {
        
        dataRequest = requestManager?.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseJSON { responseJson in
                
                Logger.log(message: "GET " + (responseJson.request?.url?.absoluteString ?? ""), messageType: .debug)
                
                do {
                    guard let data = responseJson.data, responseJson.result.error == nil
                        else {
                            Logger.log(message: "Error", messageType: .error)
                            completion(nil, responseJson.result.error, nil)
                            return
                    }
                    
                    if let json = responseJson.result.value as? [String: Any?] {
                        Logger.log(message: json.description, messageType: .debug)
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    
                    completion(responseModel, nil, data)
                    
                } catch let error {
                    Logger.log(message: error.localizedDescription, messageType: .error)
                    completion(nil, error as NSError, nil)
                }
        }
    }
    
    private func cancelRequest() {
        dataRequest?.cancel()
    }
    
}
