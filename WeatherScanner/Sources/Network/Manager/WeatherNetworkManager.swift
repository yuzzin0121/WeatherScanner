//
//  WeatherNetworkManager.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation
import Alamofire
import RxSwift

final class WeatherNetworkManager: NetworkServiceProtocol {
    static let shared = WeatherNetworkManager()
    
    func request<T: Decodable, U: TargetType>(model: T.Type, router: U) -> Single<Result<T, Error>> {
        return Single<Result<T, Error>>.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let model):
                            single(.success(.success(model)))
                        case .failure(let error):
                            print("failure: \(error)")
                            guard let statusCode = response.response?.statusCode else {
                                single(.success(.failure(WeatherAPIError.notFound)))
                                return
                            }
                            if let apiError = WeatherAPIError(rawValue: statusCode) {
                                single(.success(.failure(apiError)))
                            }
                        }
                    }
            } catch {
                print(error)
                single(.success(.failure(WeatherAPIError.notFound)))
            }
            
            return Disposables.create()
        }
    }
}
