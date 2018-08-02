//
//  ServiceResult.swift
//  EventSearch
//
//  Created by Tyler Poland on 8/1/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import Foundation
import Alamofire

enum ServiceResult<V> {
    case success(V)
    case failure(Error)
}

enum ServiceError: Error {
    case newTokenInvalid
    case unexpectedServerError
}

typealias ServiceMethod = HTTPMethod

func serviceJSONEncoder(_ request: URLRequest, params: [String: Any]?) -> URLRequest? {
    return try? JSONEncoding().encode(request, with: params)
}

func serviceJSONEncodable<T>(_ request: URLRequest, encodable: T) -> URLRequest? where T: Encodable {
    guard let data = try? JSONEncoder().encode(encodable),
        let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return nil
    }
    return try? JSONEncoding().encode(request, withJSONObject: jsonObj)
}

protocol ServiceRoutable {
    var routerName: String { get }
    var method: ServiceMethod { get }
    var path: String? { get }
    var url: URL? { get }
    var urlRequest: URLRequest? { get }
}

extension ServiceRoutable {
    var routerName: String {
        return String(describing: type(of: self))
    }
    var url: URL? {
        return BaseUrl.url(for: path)
    }
    
    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }
        
        return try? URLRequest(url: url, method: method)
    }
}

enum UnauthorizedApproach {
    
    case retry, error, ignore
}

protocol Serviceable {}

extension Serviceable {
    
    @discardableResult
    func networkJSONRequest<T>(_ request: URLRequest?,
                               processor: ProcessorBase<T>,
                               unauthorizedApproach: UnauthorizedApproach = .retry,
                               shouldShowNetworkError: Bool = true,
                               isDecodable: Bool = false,
                               authString: String? = nil,
                               completion: ((ServiceResult<T>) -> ())?) -> URLSessionTask? {
        
        guard var request = request else {
            handleMissingRequestError(with: processor, isDecodable: isDecodable, completion: completion)
            return nil
        }

        
        NetworkManager.shared.startRequestsImmediately = true
        
        return send(request, with: processor, unauthorizedApproach: unauthorizedApproach, isDecodable: isDecodable, completion: completion)
    }
    
    private func setHeaders(for request: inout URLRequest, accessToken: String, jwt: String) {
        request.setValue(jwt, forHTTPHeaderField: "ID_Token")
        if request.value(forHTTPHeaderField: "Accept") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
    }
    
    @discardableResult
    private func send<T>(_ request: URLRequest,
                         with processor: ProcessorBase<T>,
                         unauthorizedApproach: UnauthorizedApproach = .error,
                         isDecodable: Bool,
                         completion: ((ServiceResult<T>) -> ())?) -> URLSessionTask? {
        if isDecodable {
            return NetworkManager.shared.request(request).validate().responseData(completionHandler: { responseData in
                let response = responseData.map { $0 as Any }
                self.handler(response, processor: processor, unauthorizedApproach: unauthorizedApproach, isDecodable: isDecodable, completion: completion)
            }).task
        } else {
            return NetworkManager.shared.request(request).validate().responseJSON(completionHandler: { response in
                self.handler(response, processor: processor, unauthorizedApproach: unauthorizedApproach, isDecodable: isDecodable, completion: completion)
            }).task
        }
    }
    
    func handler<T>(_ response: DataResponse<Any>,
                    processor: ProcessorBase<T>,
                    unauthorizedApproach: UnauthorizedApproach = .error,
                    isDecodable: Bool,
                    completion: ((ServiceResult<T>) -> ())?) {
        
        switch response.result {
        case .success(let value as Data):
            processor.processData(value, completion: completion)
        case .success(let value as [String: Any]):
            processor.processResults(value, completion: completion)
        case .success(let value as [Any]):
            processor.processArrayResults(value, completion: completion)
        case .success:
            processor.processSuccess(completion: completion)
            
        case .failure(let error):
            if let responseCode = (error as? AFError)?.responseCode {
                if responseCode == 401 {
                    if unauthorizedApproach == .error {
                        // present user with some error notification & handle
                        return
                    }
                } else if responseCode == 500 || responseCode == 555 {
                    let unexpectedServerError = ServiceError.unexpectedServerError
                    completion?(.failure(unexpectedServerError))
                    return
                }
            }
            
            if let data = response.data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let values = json as? [String: Any] {
                if let code = (error as? AFError)?.responseCode, let customError = CustomError(rawValue: code) {
                    completion?(.failure(NSError.error(from: values, customError: customError)))
                } else {
                    completion?(.failure(error))
                }
            } else {
                completion?(.failure(error))
            }
            
            if (error as NSError).code != NSURLErrorCancelled {
                print(curlRepresentation(for: response.request, session: NetworkManager.shared.session))
            }
        }
    }
    
    private func handleMissingRequestError<T>(with processor: ProcessorBase<T>,
                                              isDecodable: Bool,
                                              completion: ((ServiceResult<T>) -> ())?) {
        let errorDetails = [NSLocalizedDescriptionKey: "request was nil - check that base url was successful"]
        let error = NSError(domain: "Serviceable", code: 1, userInfo: errorDetails)
        let response = DataResponse<Any>(request: nil, response: nil, data: nil, result: Result.failure(error))
        
        handler(response, processor: processor, isDecodable: isDecodable, completion: completion)
        NetworkManager.shared.startRequestsImmediately = false
    }
    
    // internal error notification (helpful whilst developing)
    private func curlRepresentation(for request: URLRequest?, session: URLSession) -> String {
        var components = ["$ curl -v"]
        guard let request = request, let url = request.url else {
            return "$ curl command could not be created"
        }
        if let httpMethod = request.httpMethod, httpMethod != HTTPMethod.get.rawValue {
            components.append("-X \(httpMethod)")
        }
        if session.configuration.httpShouldSetCookies {
            if let cookieStorage = session.configuration.httpCookieStorage, let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty {
                let string = cookies.reduce("") {
                    $0 + "\($1.name)=\($1.value);"
                }
                components.append("-b \"\(string[..<string.index(before: string.endIndex)])\"")
            }
        }
        var headers: [AnyHashable: Any] = [:]
        if let additionalHeaders = session.configuration.httpAdditionalHeaders {
            for (field, value) in additionalHeaders where field != AnyHashable("Cookie") {
                headers[field] = value
            }
        }
        if let headerFields = request.allHTTPHeaderFields {
            for (field, value) in headerFields where field != "Cookie" {
                headers[field] = value
            }
        }
        for (field, value) in headers {
            components.append("--header \"\(field): \(value)\"")
        }
        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-d \"\(escapedBody)\"")
        }
        components.append("\"\(url.absoluteString)\"")
        return components.joined(separator: " \\\n\t")
    }
    
}
