//
//  SectionOfWeatherData.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation
import RxDataSources
import CoreLocation

enum SectionOfWeatherData: SectionModelType {
    typealias ITEM = Row
    
    case currentWeatherSection(header: String, items: [Row])
    case hourlyWeatherSection(header: String, items: [Row])
    case fiveDaysWeatherSection(header: String, items: [Row])
    case locationMapSection(header: String, items: [Row])
    case detailInfoSection(header: String, items: [Row])
    
    enum Row {
        case currentWeatherData(currentWeather: CurrentWeather)
        case hourlyWeatherData(hourlyData: HourlyWeather)
        case dailyWeatherData(dailyData: DailyWeather)
        case locationData(location: [CLLocationCoordinate2D])
        case detailInfoData(detailInfo: [Double])
    }
    
    var items: [Row] {
        switch self {
            case .currentWeatherSection(_, let items): return items
            case .hourlyWeatherSection(_, let items): return items
            case .fiveDaysWeatherSection(_, let items): return items
            case .locationMapSection(_, let items): return items
            case .detailInfoSection(_, let items): return items
        }
    }
    
    public init(original: SectionOfWeatherData, items: [Row]) {
    switch original {
    case .currentWeatherSection(let header, _):
      self = .currentWeatherSection(header: header, items: items)

    case .hourlyWeatherSection(let header, _):
      self = .hourlyWeatherSection(header: header, items: items)
      
    case .fiveDaysWeatherSection(let header, _):
    self = .fiveDaysWeatherSection(header: header, items: items)
    
    case .locationMapSection(let header, _):
    self = .locationMapSection(header: header, items: items)
    
    case .detailInfoSection(let header, _):
    self = .detailInfoSection(header: header, items: items)
    }
  }
 }
