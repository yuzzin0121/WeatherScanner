//
//  WeatherRouter.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation
import Alamofire

enum WeatherRouter {
    case fetchWeather(fetchWeatherQuery: FetchWeatherQuery)
}

extension WeatherRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchWeather:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchWeather:
            return "forecast"
        }
    }
    
    var header: [String : String] {
        switch self {
        default:
            return [:]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchWeather(let fetchWeatherQuery):
            return [
                URLQueryItem(name: WeatherQueryName.lang.rawValue, value: fetchWeatherQuery.lang),
                URLQueryItem(name: WeatherQueryName.cnt.rawValue, value: fetchWeatherQuery.cnt),
                URLQueryItem(name: WeatherQueryName.lat.rawValue, value: fetchWeatherQuery.lat),
                URLQueryItem(name: WeatherQueryName.lon.rawValue, value: fetchWeatherQuery.lon),
                URLQueryItem(name: WeatherQueryName.appid.rawValue, value: APIKey.appId.rawValue)
            ]
        }
    }
    
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
    
}
