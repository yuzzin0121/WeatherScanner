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
    private let weatherEntityMapper = WeatherEntityMapper()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let sectionWeatherDataList: PublishSubject<[SectionOfWeatherData]>
        let currentWeather: Driver<String>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let sectionWeatherDataList = PublishSubject<[SectionOfWeatherData]>()
        let currentWeather = PublishRelay<String>()
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
            .bind(with: self) { owner, result in
                switch result {
                case .success(let fetchWeatherModel):
                    let sectionDataList = owner.getSectionWeatherDataList(weatherModel: fetchWeatherModel)
                    sectionWeatherDataList.onNext(sectionDataList)
                    currentWeather.accept(fetchWeatherModel.list[0].weather[0].main)
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(sectionWeatherDataList: sectionWeatherDataList,
                      currentWeather: currentWeather.asDriver(onErrorDriveWith: .empty()),
                      errorString: errorString.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func getSectionWeatherDataList(weatherModel: FetchWeatherModel) -> [SectionOfWeatherData] {
        let list = weatherModel.list
        let forecast = list[0]
        
        let currentWeather = weatherEntityMapper.toCurrentWeatherEntity(forecast)
        
        var houlyWeatherList: [SectionOfWeatherData.Row] = []
        
        var dailyForecastList: [SectionOfWeatherData.Row] = DateManager.shared.getDailyForecastList(list).map {
            return .dailyWeatherData(dailyData: weatherEntityMapper.toDailyWeatherEntity($0))
        }
        
        let locationCoor: [SectionOfWeatherData.Row] = [
            .locationData(location: [weatherEntityMapper.toCLLocationCoordinate2DEntity(weatherModel.city)])
        ]
    
        let detailInfoList: [SectionOfWeatherData.Row] = [
            .detailInfoData(detailInfo: [weatherEntityMapper.toHumidityWeatherEntity(forecast)]),
            .detailInfoData(detailInfo: [weatherEntityMapper.toCloudWeatherEntity(forecast)]),
            .detailInfoData(detailInfo: weatherEntityMapper.toWindWeatherEntity(dto: forecast.wind))
        ]
        
        list.forEach { forecast in
            if DateManager.shared.isHoulryDate(forecast.dtTxt) {
                let data: SectionOfWeatherData.Row = .hourlyWeatherData(hourlyData: weatherEntityMapper.toHourlyWeatherEntity(forecast))
                houlyWeatherList.append(data)
            }
        }
        
        let sectionOfWeatherDataList: [SectionOfWeatherData] = [
            .currentWeatherSection(header: weatherModel.city.name, items: [.currentWeatherData(currentWeather: currentWeather)]),
            .hourlyWeatherSection(header: WeatherSection.hourly.headerTitle, items: houlyWeatherList),
            .fiveDaysWeatherSection(header: WeatherSection.fiveDays.headerTitle, items: dailyForecastList),
            .locationMapSection(header: WeatherSection.locationMap.headerTitle, items: locationCoor),
            .detailInfoSection(header: "", items: detailInfoList),
        ]
        return sectionOfWeatherDataList
    }
}
