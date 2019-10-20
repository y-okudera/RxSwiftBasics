//
//  WeatherForecastAPIRequest.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/10/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

final class WeatherForecastAPIRequest: APIRequest {
    
    typealias Response = WeatherForecastAPIResponse
    typealias ErrorResponse = WeatherForecastAPIErrorResponse
    var parameters: [String: Any]
    
    init(city: String = "130010") {
        self.parameters = ["city": city]
    }
}
