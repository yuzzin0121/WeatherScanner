//
//  WeatherAPIError.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

// LocalizedError - 오류에 대한 발생 이유를 설명하는 오류 프로토콜
enum WeatherAPIError: Int, LocalizedError {
    case canNotFindAPIKey = 401
    case badRequest = 404
    case tooManyRequest = 429
    case notFound = 500
    case notFound2 = 502
    case notFound3 = 503
    case notFound4 = 504
    
    var errorDescription: String? {
        switch self {
        case .canNotFindAPIKey:
            return "인증되지 않은 요청입니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .tooManyRequest:
            return "과호출입니다."
        case .notFound, .notFound2, .notFound3, .notFound4:
            return "사전에 정의되지 않은 에러가 발생했습니다."
        }
    }
}
