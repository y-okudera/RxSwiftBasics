//
//  GourmetSearchAPIRequest.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/26.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

final class GourmetSearchAPIRequest: APIRequest {
    
    typealias Response = GourmetSearchAPIResponse
    typealias ErrorResponse = GourmetSearchAPIErrorResponse
    var parameters: [String: Any]
    
    /// 1ページあたりの取得数
    private let count = 50
    /// リクエストするページNo
    var requestPageNo = 0
    
    init(largeArea: String) {
        let apiKey = APIKeys.valueForAPIKey(named: .recruitApiKey)
        self.parameters = [
            "key": apiKey,
            "format": "json",
            "large_area": largeArea,
            "count": count
        ]
    }
}

extension GourmetSearchAPIRequest {
    func incrementRequestPageNo() {
        self.requestPageNo += 1
        self.parameters["start"] = (requestPageNo - 1) * count + 1
    }
    
    func decrementRequestPageNo() {
        self.requestPageNo -= 1
    }
    
    func resetRequestPageNo() {
        self.requestPageNo = 0
        self.parameters["start"] = 1
    }
}
