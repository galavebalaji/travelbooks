
//  KeychainService.swift

import Foundation
import Security

let kUserAccount = "AuthenticatedUser"
/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */
let kAccessToken: NSString = "accessToken" // change this

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainManager: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public class func saveAccessToken(token: NSString) {
        self.save(service: kAccessToken, data: token)
    }
    
    public class func getAccessToken() -> NSString? {
        return self.load(service: kAccessToken)
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: NSString, data: NSString) {
        
        guard let dataString = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) else {
            return
        }
        let dataFromString: NSData = dataString as NSData
        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(
            objects: [kSecClassGenericPasswordValue,
                      service,
                      kUserAccount,
                      dataFromString
            ],
            forKeys: [kSecClassValue,
                      kSecAttrServiceValue,
                      kSecAttrAccountValue,
                      kSecValueDataValue
            ]
        )
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(
            objects: [kSecClassGenericPasswordValue,
                      service,
                      kUserAccount,
                      kCFBooleanTrue,
                      kSecMatchLimitOneValue
            ],
            forKeys: [kSecClassValue,
                      kSecAttrServiceValue,
                      kSecAttrAccountValue,
                      kSecReturnDataValue,
                      kSecMatchLimitValue
            ]
        )
        
        var dataTypeRef: AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
