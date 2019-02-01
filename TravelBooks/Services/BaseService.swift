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
    
    final func getRequest<T: Decodable>(type model: T.Type,
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
