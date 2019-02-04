//
//  TravelBookTokenManager.swift
//  TravelBooks

import Foundation
import Alamofire

class TravelBookTokenManager {
    
    // shared instance to work this class across the app
    static let shared = TravelBookTokenManager()
    // Client id and client secret
    private var clientId = "3bb0640f3232379a9e07c0c44f9ef5e764eefb9ba0e1d31168a90ecebe2bc67d"
    private var clientSecret = "073177b5f4f3489d46921c62629a42aa7b2bbdf57fc578bf2c61917957d037cc"
    private var grantType = "password"
    private var userEmailId = "olivier@nimbl3.com"
    private var password = "12345678"
    
    // Avoid making an instance of this class from outside and to keep it Singleton claas
    private init() {
        
    }
    // private var to hold, save in user defalts and fetch auth token
    private var accessToken: String? {
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "token")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: "token")
            }
        }
        get {
            if let token = UserDefaults.standard.value(forKey: "token") as? String {
                return token
            }
            return nil
        }
    }
    
    func hasAccessToken() -> Bool {
        if let token = self.accessToken {
            return !token.isEmpty
        }
        return false
    }
    
    func getAccessToken() -> String? {
        return accessToken
    }
    
    func clearAccessToken() {
        accessToken = nil
    }
    
    func startAuthentication(completion: ((_ accessToken: String?, _ error: Error?) -> Void)?) {
        let parameters: [String: Any] = ["client_id": clientId,
                                         "client_secret": clientSecret,
                                         "grant_type": grantType,
                                         "email": userEmailId,
                                         "password": password
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let urlString = "https://staging.travelbook.com/api/v1/token"
        Alamofire.request(urlString,
                          method: .post,
                          parameters: parameters,
                          headers: headers).responseJSON { [weak self] jsonResponse in
                            
                            guard jsonResponse.data != nil, jsonResponse.result.error == nil
                                else {
                                    Logger.log(message: "Error", messageType: .error)
                                    completion?(nil, jsonResponse.result.error)
                                    return
                            }
                            
                            if let jsonDict = jsonResponse.result.value as? [String: Any?],
                                let accessToken = jsonDict["access_token"] as? String {
                                self?.accessToken = accessToken
                                completion?(accessToken, nil)
                            }
        }
    }
    
}
