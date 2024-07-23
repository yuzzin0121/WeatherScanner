//
//  FetchWeatherQuery.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

struct FetchWeatherQuery {
    let lat: String
    let lon: String
    let cnt: String
    let lang: String
    
    init(lat: Double, lon: Double, cnt: Int = 7, lang: String = Language.korea.rawValue) {
        self.lat = String(lat)
        self.lon = String(lon)
        self.cnt = String(cnt)
        self.lang = lang
    }
}
