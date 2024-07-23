//
//  DetailInfoRow.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation

enum DetailInfoRow: Int {
    case humidity
    case cloud
    case windSpeed
    
    var header: String {
        switch self {
        case .humidity: "습도"
        case .cloud: "구름"
        case .windSpeed: "바람 속도"
        }
    }
}
