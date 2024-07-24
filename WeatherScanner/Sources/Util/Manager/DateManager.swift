//
//  DateManager.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation

final class DateManager {
    static let shared = DateManager()
    
    let dateFormatter = DateFormatter().then { formatter in
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)    // UTC 시간대
    }
    
    let weekdayFormatter = DateFormatter().then { formatter in
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
    }
    
    let calendar = Calendar.current
    
    // 5일 동안의 일기예보 반환
    func getDailyForecastList(_ forecastList: [ForecastDTO]) -> [ForecastDTO] {
        
        let currentDate = Date()
        var selectedForecasts: [ForecastDTO] = []
        var selectedDates = Set<Date>()
        
        // 현재로부터 5일까지의 날짜 Set에 insert
        for i in 0..<5 {
            if let targetDate = calendar.date(byAdding: .day, value: i, to: currentDate) {
                selectedDates.insert(calendar.startOfDay(for: targetDate))
            }
        }
        
        for forecast in forecastList {
            guard let forecastDate = getDate(forecast.dtTxt) else {
                continue
            }
            let startOfForecastDay = calendar.startOfDay(for: forecastDate)
            if selectedDates.contains(startOfForecastDay) {
                selectedForecasts.append(forecast)  // 1일 1일기예보 저장
                selectedDates.remove(startOfForecastDay)    // 저장된 날짜 set에서 제거
            }
        }
        return selectedForecasts
    }
    
    // 현재로부터 이틀 기간인지의 여부
    func isHoulryDate(_ dateString: String) -> Bool {
        guard let date = getDate(dateString) else {
            return false
        }
        
        let currentDate = Date()
        
        let timeInterval = date.timeIntervalSince(currentDate)
        return timeInterval >= 0 && timeInterval <= (48 * 3600)
    }
    
    // 날짜를 시간으로 변환
    func convertToHour(_ dateString: String) -> String {
        guard let date = getDate(dateString) else {
            return dateString
        }
        
        guard let currentDate = getCurrentDate() else {
            return dateString
        }
        
        if calendar.isDate(date, inSameDayAs: currentDate) {
            let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
            let currentComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
            
            // 시간을 비교하여 "지금" 또는 "오전/오후 시간"으로 변환
            if dateComponents.hour == currentComponents.hour {
                return "지금"
            } else {
                return formatHourAndMinute(dateComponents)
            }
        } else {
            let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
            return formatHourAndMinute(dateComponents)
        }
    }
    
    // 오후 or 오전 반환
    func formatHourAndMinute(_ dateComponents: DateComponents) -> String {
        let hour = dateComponents.hour ?? 0
        let isPM = hour >= 12
        let formattedHour = hour % 12 == 0 ? 12 : hour % 12
        let period = isPM ? "오후" : "오전"
        return "\(period) \(formattedHour)시"
    }
    
    // 날짜를 요일로 변환
    func convertDayOfWeek(_ dateString: String) -> String {
        guard let date = getDate(dateString) else {
            return dateString
        }
        
        let currentDate = Date()
        
        // 주어진 날짜와 현재 날짜를 비교
        if calendar.isDate(date, inSameDayAs: currentDate) {
            return "오늘"
        } else {
            let weekdayString = weekdayFormatter.string(from: date)
            return weekdayString
        }
    }
    
    func getDate(_ dateString: String) -> Date? {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return date
    }
    
    func getCurrentDate() -> Date? {
        let currentDate = Date()
        
        dateFormatter.timeZone = TimeZone.current
        let crrentDateString = dateFormatter.string(from: currentDate)
        guard let currentDate = dateFormatter.date(from: crrentDateString) else {
            return nil
        }
        return currentDate
    }
}
