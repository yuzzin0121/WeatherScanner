//
//  CityManager.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation
import RxSwift

final class CityManager {
    static let shared = CityManager()
    private var cityList: [City] = []
    
    private init() { }
    
    // 도시 검색
    func searchCity(name: String) -> Single<Result<[City], Error>> {
        return Single<Result<[City], Error>>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            if name.isEmpty {
                single(.success(.success(cityList)))
            }
            
            let lowercaseName = name.lowercased()
            var searchedList: [City] = []
            
            for city in cityList {
                if city.name.lowercased().contains(lowercaseName) {
                    searchedList.append(city)
                }
            }
        
            single(.success(.success(searchedList)))
            
            return Disposables.create()
        }
    }
    
    // 첫 날씨화면에 나올 도시 반환
    func getDefaultCity() -> City? {
        let defaultCityName = "Seongnam"
        if !cityList.isEmpty {
            for city in cityList {
                if city.name == defaultCityName {
                    return city
                }
            }
        }
        return nil
    }
    
    func getCityList() -> [City] {
        return cityList
    }
    
    func saveToCityList(completionHandler: ((Bool) -> Void)) {
        self.cityList = decodeToCityList()
        completionHandler(true)
    }
    
    // 구조체 배열로 변환
    private func decodeToCityList() -> [City] {
        guard let url = getJsonUrl() else {
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
