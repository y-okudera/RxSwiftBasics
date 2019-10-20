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
    
    /// API Request
    static func request<T: APIRequest>(request: T) -> Single<Decodable> {
        
        return Single.create { singleEvent in
            
            // 端末の通信状態をチェック
            if !isReachable() {
                singleEvent(.error(APIError.connectionError))
                return Disposables.create()
            }
            
            guard let urlRequest = request.makeURLRequest() else {
                singleEvent(.error(APIError.invalidRequest))
                return Disposables.create()
            }
            
            print("urlRequest: \(urlRequest)")
            let request = Alamofire.request(urlRequest).validate(statusCode: 200 ..< 300).responseData { dataResponse in
                
                // エラーチェック
                if let error = dataResponse.result.error {
                    let apiError = errorToAPIError(error: error, statusCode: dataResponse.response?.statusCode)
                    singleEvent(.error(apiError))
                    return
                }
                
                // レスポンスデータのnilチェック
                guard let responseData = dataResponse.result.value else {
                    singleEvent(.error(APIError.invalidResponse))
                    return
                }
                
                // APIレスポンスをデコード
                if let object = request.decode(data: responseData) {
                    print("response:\(object)")
                    singleEvent(.success(object))
                    return
                }
                
                // APIエラーレスポンスをデコード
                if let apiErrorObject = request.decode(errorResponseData: responseData) {
                    print("apiErrorObject:\(apiErrorObject)")
                    singleEvent(.error(APIError.errorResponse(errObject: apiErrorObject)))
                    return
                }
                
                print("Decoding failure.")
                singleEvent(.error(APIError.decodeError))
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
        print("HTTP status code:\(String(describing: statusCode))")
        if let error = error as? URLError {
            if error.code == .timedOut {
                print("timed out.")
                return .connectionError
            }
            if error.code == .notConnectedToInternet {
                print("Not connected to internet.")
                return .connectionError
            }
        }
        print("dataResponse.result.error:\(error)")
        return .others(error: error, statusCode: statusCode)
    }
}
