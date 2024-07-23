//
//  WeatherViewModel.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import RxSwift
import RxCocoa

final class WeatherViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let errorString = PublishRelay<String>()
        
        input.viewDidLoadTrigger
            .map {
                let city = CityManager.shared.getDefaultCity()
                return city
            }
            .flatMap { city in
                guard let city else { return Single<Result<FetchWeatherModel, Error>>.never() }
                return WeatherNetworkManager.shared.request(model: FetchWeatherModel.self,
                                                             router: WeatherRouter.fetchWeather(
                                                                fetchWeatherQuery: FetchWeatherQuery(
                                                                    lat: city.coord.lat,
                                                                    lon: city.coord.lon)
                                                             )
                )
            }
            .bind { result in
                switch result {
                case .success(let success):
                    print(success.list)
                    
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(errorString: errorString.asDriver(onErrorDriveWith: .empty()))
    }
}
