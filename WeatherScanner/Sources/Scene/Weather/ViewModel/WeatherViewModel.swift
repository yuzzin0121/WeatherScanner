//
//  WeatherViewModel.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import RxSwift
import RxCocoa
import RxDataSources
import CoreLocation

final class WeatherViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    private let weatherEntityMapper = WeatherEntityMapper()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let searchBarTapped: Observable<Void>
        let fetchWeatherOfCity: Observable<City>
    }
    
    struct Output {
        let searchButtonTapped: Driver<Void>
        let sectionWeatherDataList: PublishSubject<[SectionOfWeatherData]>
        let currentWeather: Driver<String>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let searchButtonTapped = PublishRelay<Void>()
        let sectionWeatherDataList = PublishSubject<[SectionOfWeatherData]>()
        let currentWeather = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()
        
        input.searchBarTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { _ in
                searchButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
        
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
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.fetchWeatherOfCity
            .flatMap { city in
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
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(searchButtonTapped: searchButtonTapped.asDriver(onErrorDriveWith: .empty()),
                      sectionWeatherDataList: sectionWeatherDataList,
                      currentWeather: currentWeather.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorMessage.asDriver(onErrorDriveWith: .empty()))
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
        
        let listCount: Double = Double(list.count)
        
        var humiditySum = 0.0
        var cloudSum = 0.0
        var windSpeedSum = 0.0
        var gustSum = 0.0
        
        list.forEach { foreCastDto in
            if DateManager.shared.isHoulryDate(foreCastDto.dtTxt) {
                let data: SectionOfWeatherData.Row = .hourlyWeatherData(hourlyData: weatherEntityMapper.toHourlyWeatherEntity(foreCastDto))
                houlyWeatherList.append(data)
            }
            
            humiditySum += Double(foreCastDto.main.humidity)
            cloudSum += Double(foreCastDto.clouds.all)
            windSpeedSum += foreCastDto.wind.speed
            gustSum += foreCastDto.wind.gust
        }
        
        let humidityAvg = humiditySum / listCount
        let cloudAvg = cloudSum / listCount
        let windSpeedAvg = windSpeedSum / listCount
        let gustAvg = gustSum / listCount
        
        let detailInfoList: [SectionOfWeatherData.Row] = [
            .detailInfoData(detailInfo: [humidityAvg]),
            .detailInfoData(detailInfo: [cloudAvg]),
            .detailInfoData(detailInfo: [windSpeedAvg, gustAvg])
        ]
        
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


enum SectionOfWeatherData: SectionModelType {
    typealias ITEM = Row
    
    case currentWeatherSection(header: String, items: [Row])
    case hourlyWeatherSection(header: String, items: [Row])
    case fiveDaysWeatherSection(header: String, items: [Row])
    case locationMapSection(header: String, items: [Row])
    case detailInfoSection(header: String, items: [Row])
    
    enum Row {
        case currentWeatherData(currentWeather: CurrentWeather)
        case hourlyWeatherData(hourlyData: HourlyWeather)
        case dailyWeatherData(dailyData: DailyWeather)
        case locationData(location: [CLLocationCoordinate2D])
        case detailInfoData(detailInfo: [Double])
    }
    
    var items: [Row] {
        switch self {
            case .currentWeatherSection(_, let items): return items
            case .hourlyWeatherSection(_, let items): return items
            case .fiveDaysWeatherSection(_, let items): return items
            case .locationMapSection(_, let items): return items
            case .detailInfoSection(_, let items): return items
        }
    }
    
    init(original: SectionOfWeatherData, items: [Row]) {
    switch original {
    case .currentWeatherSection(let header, _):
      self = .currentWeatherSection(header: header, items: items)

    case .hourlyWeatherSection(let header, _):
      self = .hourlyWeatherSection(header: header, items: items)
      
    case .fiveDaysWeatherSection(let header, _):
    self = .fiveDaysWeatherSection(header: header, items: items)
    
    case .locationMapSection(let header, _):
    self = .locationMapSection(header: header, items: items)
    
    case .detailInfoSection(let header, _):
    self = .detailInfoSection(header: header, items: items)
    }
  }
 }
