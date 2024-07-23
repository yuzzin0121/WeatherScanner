//
//  CityManager.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

final class CityManager {
    static let shared = CityManager()
    
    // 구조체 배열로 변환
    func getCityList() -> [City] {
        print(#function)
        guard let url = getJsonUrl() else {
            // 에러 처리 필요
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let cityList = try decoder.decode([City].self, from: data)
            return cityList
        } catch {
            print("Failed to load and decode JSON: \(error)")
            return []
        }
    }
    
    // json url 반환
    private func getJsonUrl() -> URL? {
        let fileName = "reduced_citylist"
        let extensionType = "json"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
            print("파일을 찾을 수 없음")
            return nil
        }
        return url
    }
}
