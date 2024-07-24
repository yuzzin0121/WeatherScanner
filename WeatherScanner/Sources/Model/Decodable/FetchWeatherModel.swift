//
//  FetchWeatherModel.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

struct FetchWeatherModel: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastDTO]    // 일기예보 리스트
    let city: City
}

struct ForecastDTO: Decodable {
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case clouds
        case wind
        case dtTxt = "dt_txt"
    }
}

struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct Clouds: Decodable {
    let all: Int
}


struct Wind: Decodable {
    let speed: Double
    let gust: Double
}
