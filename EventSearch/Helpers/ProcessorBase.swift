//
//  ProcessorBase.swift
//  EventSearch
//
//  Created by Tyler Poland on 8/1/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import Foundation

import Foundation

enum JSONParseError: Error {
    case couldNotDeenvelope(processor: String, envelope: String)
    case couldNotCreateObject(named: String, processor: String)
}

enum DataParseError: Error {
    case nilData(named: String, processor: String)
}

class ProcessorBase<T> {
    func customError() -> CustomError { return .serverMessage }
    
    private var notImplementedError = NSError(domain: "Service Processor", code: 1, userInfo: [NSLocalizedDescriptionKey: "No processor implemented"])
    
    func processResults(_ json: [String: Any], completion: ((ServiceResult<T>) -> ())?) {
        // no op
        completion?(.failure(notImplementedError))
    }
    
    func processArrayResults(_ json: [Any], completion: ((ServiceResult<T>) -> ())?) {
        // no op
        completion?(.failure(notImplementedError))
    }
    
    func processSuccess(completion: ((ServiceResult<T>) -> ())?) {
        // no op
        completion?(.failure(notImplementedError))
    }
    
    func processData(_ data: Data, completion: ((ServiceResult<T>) -> ())?) {
        // no op
        completion?(.failure(notImplementedError))
    }
}
