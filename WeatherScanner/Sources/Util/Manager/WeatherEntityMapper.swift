//
//  WeatherEntityMapper.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation
import CoreLocation

struct WeatherEntityMapper {
    func toCurrentWeatherEntity(_ dto: ForecastDTO) -> CurrentWeather {
        let entity = CurrentWeather(
            temp: Int(dto.main.temp.kelvinToCelsius()),
            weather: dto.weather[0].description,
            tempMin: Int(dto.main.tempMin.kelvinToCelsius()),
            tempMax: Int(dto.main.tempMax.kelvinToCelsius()))
        return entity
    }
    
    func toHourlyWeatherEntity(_ dto: ForecastDTO) -> HourlyWeather {
        let entity = HourlyWeather(
            time: DateManager.shared.convertToHour(dto.dtTxt),
            icon: dto.weather[0].icon,
            temp: Int(dto.main.temp.kelvinToCelsius()))
        
        return entity
    }
    
    func toDailyWeatherEntity(_ dto: ForecastDTO) -> DailyWeather {
        let entity = DailyWeather(
            dt: DateManager.shared.convertDayOfWeek(dto.dtTxt),
            icon: dto.weather[0].icon,
            tempMin: Int(dto.main.tempMin.kelvinToCelsius()),
            tempMax: Int(dto.main.tempMax.kelvinToCelsius()))
        
        return entity
    }
    
    func toCLLocationCoordinate2DEntity(_ dto: City) -> CLLocationCoordinate2D {
        let entity = CLLocationCoordinate2D(
            latitude: dto.coord.lat,
            longitude: dto.coord.lon)
        
        return entity
    }
}

