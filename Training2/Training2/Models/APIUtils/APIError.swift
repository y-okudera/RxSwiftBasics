//
//  APIError.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/08/04.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

enum APIError: Error {
    /// 接続エラー(オフライン or タイムアウト)
    case connectionError
    /// レスポンスのデコード失敗
    case decodeError
    /// エラーレスポンス
    case errorResponse(errObject: Decodable)
    /// 無効なリクエスト
    case invalidRequest
    /// 無効なレスポンス
    case invalidResponse
    /// その他
    case others(error: Error, statusCode: Int?)
    
    var message: String {
        switch self {
        case .connectionError:
            return "通信エラー"
        case .decodeError:
            return "デコードエラー"
        case .errorResponse(errObject: let errObject):
            return "APIエラー:\(errObject)"
        case .invalidRequest:
            return "リクエスト不正"
        case .invalidResponse:
            return "レスポンス不正"
        case .others(error: let error, statusCode: let statusCode):
            return "その他エラー:\(error) HTTPステータスコード:\(String(describing: statusCode))"
        }
    }
}
