//
//  NetworkServiceProtocol.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol: AnyObject {
    func request<T: Decodable, U: TargetType>(model: T.Type, router: U) -> Single<Result<T, Error>>
}
