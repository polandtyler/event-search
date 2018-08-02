//
//  BaseURL.swift
//  EventSearch
//
//  Created by Tyler Poland on 8/1/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import Foundation

final class BaseUrl {
    
    enum SearchType: String {
        case events = "events"
        case performers = "performers"
    }
    
    static private let baseURL = AppStrings.baseURL
    static private let clientID = AppStrings.clientID
    
    class func url(for path: String?) -> URL? {
        
        let path = path?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "\(baseURL)\(path)?client_id=\(clientID)")
    }

}
