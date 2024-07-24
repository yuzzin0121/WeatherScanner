//
//  CityError.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation

enum CityError: LocalizedError {
    case notFound
    case dataEmpty
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "알 수 없는 오류가 발생했습니다. \n다시 시도해주세요."
        case .dataEmpty: return "검색된 결과가 없습니다."
            
        }
    }
}
