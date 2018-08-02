//
//  NSError+Exts.swift
//  EventSearch
//
//  Created by Tyler Poland on 8/1/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import Foundation

enum CustomError: Int {
    case badError, nilID, nilSearchString, badURL, serverMessage, nilData, timeout
}

private let errorMessages: [Int: String] = [
    CustomError.badError.rawValue: "No error message for specified error code",
    CustomError.nilID.rawValue: "ID cannot be nil",
    CustomError.nilSearchString.rawValue: "Search string cannot be nil",
    CustomError.badURL.rawValue: "URL could not be created with given input",
    CustomError.nilData.rawValue: "Data could not be serialized. Input data was nil.",
    CustomError.timeout.rawValue: "Request timed out"
]

extension NSError {
    convenience init(customError: CustomError, errorMessage: String? = nil) {
        let domain = Bundle.main.bundleIdentifier ?? ""
        let errorCode = customError.rawValue
        
        if let errorMessage = errorMessage, errorCode == CustomError.serverMessage.rawValue {
            self.init(domain: domain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        } else if let errorMessage = errorMessage {
            self.init(domain: domain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        } else if let errorMessage = errorMessages[errorCode] {
            self.init(domain: domain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        } else {
            let errorCode = CustomError.badError.rawValue
            let errorMessage = errorMessages[errorCode] ?? ""
            self.init(domain: domain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage, NSLocalizedRecoverySuggestionErrorKey: "Add a message to the errorMessages dictionary in NSErrorExtensions.swift"])
        }
    }
    
    class func error(from json: [String: Any], customError: CustomError) -> NSError {
        var errorMessage: String?
        if let json = json["errors"] as? [String: Any] {
            if let detail = json["detail"] as? String {
                errorMessage = detail
            }
        } else if let json = json["errors"] as? [[String: Any]] {
            for error in json {
                if let detail = error["detail"] as? String {
                    if errorMessage == nil {
                        errorMessage = detail
                    } else {
                        errorMessage?.append("\n\(detail)")
                    }
                }
            }
        }
        return NSError(customError: customError, errorMessage: errorMessage)
    }
}
