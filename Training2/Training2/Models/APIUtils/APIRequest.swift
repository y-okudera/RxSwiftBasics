//
//  APIRequest.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/08/04.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation

// MARK: - Protocol
protocol APIRequest {
    
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable
    
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var encodingType: EncodingType { get }
    var httpHeaderFields: [String: String] { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var allowsCellularAccess: Bool { get }
    
    func decode(data: Data) -> Response?
    func decode(errorResponseData: Data) -> ErrorResponse?
    
    /// URLRequestを生成する
    func makeURLRequest() -> URLRequest?
}

// MARK: - Default implementation
extension APIRequest {
    
    var baseURL: URL {
        guard let url = URL(string: "http://weather.livedoor.com/forecast/webservice/json/v1") else {
            fatalError("baseURL is nil.")
        }
        return url
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var parameters: [String: Any] {
        return [:]
    }
    
    var encodingType: EncodingType {
        return .urlEncoding
    }
    
    var httpHeaderFields: [String: String] {
        return [:]
    }
    
    var timeoutInterval: TimeInterval {
        return 30
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var allowsCellularAccess: Bool {
        return true
    }
    
    func decode(data: Data) -> Response? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            print("Response decode error:\(error)")
            return nil
        }
    }
    
    func decode(errorResponseData: Data) -> ErrorResponse? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(ErrorResponse.self, from: errorResponseData)
        } catch {
            print("ErrorResponse decode error:\(error)")
            return nil
        }
    }
    
    func makeURLRequest() -> URLRequest? {
        
        let endPoint = baseURL.absoluteString + path
        
        // String to URL
        guard let url = URL(string: endPoint) else {
            assertionFailure("エンドポイントが不正\nendPoint:\(endPoint)")
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        urlRequest.allowsCellularAccess = allowsCellularAccess
        
        // パラメータをエンコードする
        switch encodingType {
        case .jsonEncoding:
            return urlRequest.jsonEncoding(parameters: parameters)
        case .urlEncoding:
            return urlRequest.urlEncoding(parameters: parameters)
        }
    }
}

// MARK: - Private func
private extension URLRequest {
    
    /// URLEncodingする
    ///
    /// - Parameter parameters: リクエストパラメータ
    /// - Returns: URLEncodingしたURLRequest
    mutating func urlEncoding(parameters: [String: Any]) -> URLRequest? {
        do {
            self = try Alamofire.URLEncoding.default.encode(self, with: parameters)
            return self
        } catch {
            assertionFailure("URLEncodingでエラー発生\nURLRequest:\(self)")
            return nil
        }
    }
    
    /// JSONEncodingする
    ///
    /// - Parameter parameters: リクエストパラメータ
    /// - Returns: JSONEncodingしたURLRequest
    mutating func jsonEncoding(parameters: [String: Any]) -> URLRequest? {
        do {
            self = try Alamofire.JSONEncoding.default.encode(self, with: parameters)
            return self
        } catch {
            assertionFailure("JSONEncodingでエラー発生\nURLRequest:\(self)")
            return nil
        }
    }
}
