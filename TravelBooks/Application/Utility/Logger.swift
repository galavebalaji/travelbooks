//
//  Logger.swift

import Foundation

enum LoggerMessageType: String {
    case debug = "Debug Info:"
    case error = "Error Info:"
    case warning = "Warning Info:"
    case info = "Info:"
}

// Logger class which will print logs along with file name date and line number where it call from
class Logger {
    static private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : (components.last ?? "")
    }
    
    class func log(message: String, messageType: LoggerMessageType, fileName: String = #file, lineNumber: Int = #line, function: String = #function) {
        #if DEBUG
            var logString = Logger.dateFormatter.string(from: Date())
            logString.append(" [" + messageType.rawValue + "]")
            logString.append(" [" + Logger.sourceFileName(filePath: fileName) + "]")
            print("\n\(logString): \(lineNumber) -> \(message)")
        #endif
    }
}
