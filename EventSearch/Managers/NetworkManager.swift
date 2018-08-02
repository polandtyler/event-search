//
//  NetworkManager.swift
//  EventSearch
//
//  Created by Tyler Poland on 8/1/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {

    static var shared = SessionManager.default
    
    private lazy var configuration: URLSessionConfiguration = {
        var config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 30
        config.timeoutIntervalForRequest = 30
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return config
    }()
}
