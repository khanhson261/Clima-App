//
//  WeatherData.swift
//  Clima
//
//  Created by Tran Son on 6/20/22.
//
//

import Foundation

struct WeatherData: Decodable {
    let main: Main
    let name: String
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
