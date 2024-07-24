//
//  WeatherViewController.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol SendCityDelegate: AnyObject {
    func sendCity(_ city: City)
}

final class WeatherViewController: BaseViewController, SendCityDelegate {
    private let mainView = WeatherView()
    
    private let viewModel: WeatherViewModel
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfWeatherData>!
    private let fetchWeatherOfCity = PublishSubject<City>()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        configureCollectionViewDataSource()
        
        let input = WeatherViewModel.Input(viewDidLoadTrigger: Observable.just(()),
                                           searchBarTapped: mainView.tapButton.rx.tap.asObservable(),
                                           fetchWeatherOfCity: fetchWeatherOfCity.asObservable())
        let output = viewModel.transform(input: input)
        
        output.sectionWeatherDataList
            .bind(to: mainView.weatherCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.currentWeather
            .drive(with: self) { owner, weatherString in
                owner.mainView.setWeatherBackgroundImage(weatherString: weatherString)
            }
            .disposed(by: disposeBag)
        
        output.searchButtonTapped
            .drive(with: self) { owner, _ in
                owner.showSearchVC()
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, errorMessage in
                owner.showAlert(title: "일기예보 탐색", message: errorMessage, actionHandler: nil)
            }
            .disposed(by: disposeBag)
    }
    
    // 검색 화면 present, delegate 설정
    func showSearchVC() {
        let searchVC = SearchViewController(viewModel: SearchViewModel())
        searchVC.sendCityDelegate = self
        present(searchVC, animated: true)
    }

    override func loadView() {
        view = mainView
    }
    
    func sendCity(_ city: City) {
        mainView.startLoading()
        fetchWeatherOfCity.onNext(city)
    }
}

extension WeatherViewController {
    private func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfWeatherData>(configureCell: { dataSource, collectionView, indexPath, weatherData in
            switch dataSource[indexPath] {
            case .currentWeatherData(let currentWeather):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCollectionViewCell.identifier, for: indexPath) as? CurrentWeatherCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configureCell(currentWeather: currentWeather)
                
                return cell
            case .hourlyWeatherData(let hourlyData):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as? HourlyWeatherCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configureCell(hourlyWeatherData: hourlyData)
                
                return cell
            case .dailyWeatherData(let dailyData):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.identifier, for: indexPath) as? DailyWeatherCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configureCell(dailyWeather: dailyData)
                
                return cell
            case .locationData(let location):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationMapCollectionViewCell.identifier, for: indexPath) as? LocationMapCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configureCell(locationCoor: location[0])
                
                return cell
            case .detailInfoData(let detailInfo):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherInfoCollectionViewCell.identifier, for: indexPath) as? WeatherInfoCollectionViewCell else {
                    return UICollectionViewCell()
                }
                var title = ""
                if let row = DetailInfoRow(rawValue: indexPath.row) {
                    title = row.header
                }
                cell.configureCell(title: title, infoValue: detailInfo)
                
                return cell
                
            }
        }, configureSupplementaryView: { dataSource, collectionView, string, indexPath in
            let section = dataSource.sectionModels[indexPath.section]
            switch section {
            case .currentWeatherSection(let header, _):
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherHeaderCollectionReusableView.identifier, for: indexPath) as? CurrentWeatherHeaderCollectionReusableView else {
                    return UICollectionReusableView()
                }
                
                headerView.configureHeader(locationName: header)
                
                return headerView
            case .hourlyWeatherSection(let header, _),
                    .fiveDaysWeatherSection(let header, _),
                    .locationMapSection(let header, _):
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleCollectionReusableView.identifier, for: indexPath) as? HeaderTitleCollectionReusableView else {
                    return UICollectionReusableView()
                }
                
                headerView.configureHeader(title: header)
                return headerView
            case .detailInfoSection(_, _):
                return UICollectionReusableView()
            }
        })
    }
}

extension WeatherViewController {
    enum DetailInfoRow: Int {
        case humidity
        case cloud
        case windSpeed
        
        var header: String {
            switch self {
            case .humidity: "습도"
            case .cloud: "구름"
            case .windSpeed: "바람 속도"
            }
        }
    }
}
