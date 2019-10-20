//
//  WeatherForecastAPIResponse.swift
//  Training2
//
//  Created by Yuki Okudera on 2019/10/21.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct WeatherForecastAPIResponse: Decodable {
    var forecasts = [Forecasts]()
    var title: String?
    var description = Description()
}

// MARK: - Forecasts
struct Forecasts: Decodable {
    var dateLabel: String?
    var telop: String?
    var date: String?
    var temperature: Temperature?
    var image: Image?
}

struct Temperature: Decodable {
    var min: Min?
    var max: Max?
}

struct Min: Decodable {
    var celsius: String?
    var fahrenheit: String?
}

struct Max: Decodable {
    var celsius: String?
    var fahrenheit: String?
}

struct Image: Decodable {
    var width = 0
    var height = 0
    var url: String?
    var title: String?
}

// MARK: - Description

struct Description: Decodable {
    var text: String?
}

// MARK: - Error

struct WeatherForecastAPIErrorResponse: Decodable {
    
}
