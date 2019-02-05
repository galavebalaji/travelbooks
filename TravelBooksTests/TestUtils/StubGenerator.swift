//
//  StubGenerator.swift

import Foundation

class StubGenerator {
    
    private func getFileContentsAsJson(fileUrl: URL) -> Data? {
        if let data = try? Data(contentsOf: fileUrl) {
            return data
        }
        return nil
    }
    
    func getFeedData() -> Data? {
        let testBundle = Bundle(for: type(of: self))
        
        if let fileUrl = testBundle.url(forResource: "feeds", withExtension: "json") {
            if let data = getFileContentsAsJson(fileUrl: fileUrl) {
                return data
            }
        }
        return nil
    }
    
}
