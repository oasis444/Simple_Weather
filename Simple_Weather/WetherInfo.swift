//
//  WetherInfo.swift
//  Simple_Weather
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation

struct WeatherInfo: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {  // JSON 데이터와 키가 다른 경우 Key 맵핑을 해야 함
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey { // JSON 데이터와 키가 다른 경우 Key 맵핑을 해야 함
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
