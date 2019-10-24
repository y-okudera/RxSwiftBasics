//
//  APIClient.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/08/04.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

struct APIClient {
    
    /// The range of acceptable status codes.
    private static let acceptableStatusCodes = 200 ..< 300
    
    /// API Request
    static func request<T: APIRequest>(request: T) -> Single<T.Response> {
        
        return Single.create { singleEvent in
            
            // 端末の通信状態をチェック
            if !isReachable() {
                singleEvent(.error(APIError.connectionError))
                Logger.error(APIError.connectionError.message)
                return Disposables.create()
            }
            
            // URLRequestを生成
            guard let urlRequest = request.makeURLRequest() else {
                singleEvent(.error(APIError.invalidRequest))
                Logger.error(APIError.invalidRequest.message)
                return Disposables.create()
            }
            Logger.info("URLRequest: \(urlRequest)")
            
            let request = Alamofire
                .request(urlRequest)
                .validate(statusCode: self.acceptableStatusCodes)
                .responseData { dataResponse in
                    
                    // エラーチェック
                    if let error = dataResponse.result.error {
                        let statusCode = dataResponse.response?.statusCode
                        let apiError = errorToAPIError(error: error, statusCode: statusCode)
                        singleEvent(.error(apiError))
                        Logger.error(apiError.message)
                        return
                    }
                    
                    // レスポンスデータのnilチェック
                    guard let responseData = dataResponse.result.value else {
                        singleEvent(.error(APIError.invalidResponse))
                        Logger.error(APIError.invalidResponse.message)
                        return
                    }
                    
                    // デコード処理
                    let decodeResult = request.decode(data: responseData)
                    switch decodeResult {
                    case .success(let responseObject):
                        singleEvent(.success(responseObject))
                    case .failure(let decodeError):
                        singleEvent(.error(decodeError))
                    }
            }
            return Disposables.create { request.cancel() }
        }
    }
}

extension APIClient {
    
    /// ネットワーク状態をチェックする
    ///
    /// - Returns: true: ホストに接続成功, false: ホストに接続失敗
    private static func isReachable() -> Bool {
        if let reachabilityManager = NetworkReachabilityManager() {
            reachabilityManager.startListening()
            return reachabilityManager.isReachable
        }
        return false
    }
    
    /// ErrorをAPIErrorに変換する
    private static func errorToAPIError(error: Error, statusCode: Int?) -> APIError {
        Logger.info("HTTP status code:\(String(describing: statusCode))")
        if let error = error as? URLError {
            if error.code == .timedOut {
                Logger.error("timed out.")
                return .connectionError
            }
            if error.code == .notConnectedToInternet {
                Logger.error("Not connected to internet.")
                return .connectionError
            }
        }
        Logger.error("dataResponse.result.error:\(error)")
        return .others(error: error, statusCode: statusCode)
    }
}
