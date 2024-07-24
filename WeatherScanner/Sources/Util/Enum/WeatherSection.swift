//
//  WeatherSection.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation

enum WeatherSection: Int, CaseIterable {
    case currentWeather // 현재 날씨
    case hourly         // 시간별 일기예보(2일)
    case fiveDays       // 5일간의 일기예보
    case locationMap    // 현재 도시의 위치(지도)
    case humidity       // 습도
    case clouds         // 구름
    case windSpeed      // 바람 속도
    
    var headerTitle: String {
        switch self {
        case .hourly: "시간별 일기예보"
        case .fiveDays: "5일간의 일기예보"
        case .locationMap: "현재 도시의 위치"
        case .humidity: "습도"
        case .clouds: "구름"
        case .windSpeed: "바람 속도"
        default: "날씨"
        }
    }
}
