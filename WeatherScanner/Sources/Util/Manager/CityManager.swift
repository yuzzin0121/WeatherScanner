//
//  CityManager.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

final class CityManager {
    static let shared = CityManager()
    
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
