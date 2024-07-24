//
//  WeatherView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit
import NVActivityIndicatorView

final class WeatherView: BaseView {
    let searchBar = SearchBar(placeholder: "도시 검색")
    let tapButton = UIButton()
    
    let activityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .orbit, color: .systemYellow)
    
    private let weatherBackgroundImageView = UIImageView()
    lazy var weatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())

    func setWeatherBackgroundImage(weatherString: String) {
        print(weatherString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self else { return }
            activityIndicatorView.stopAnimating()
            
            weatherBackgroundImageView.image = UIImage(named: weatherString)
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self else { return }
                setAlphaZero(false)
            }
        }
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            setAlphaZero(true)
        }
        
        activityIndicatorView.startAnimating()
    }
    
    private func setAlphaZero(_ isZero: Bool) {
        searchBar.alpha = isZero ? 0 : 1
        weatherBackgroundImageView.alpha = isZero ? 0 : 1
        weatherCollectionView.alpha = isZero ? 0 : 1
    }
    
    override func configureHierarchy() {
        addSubview(weatherBackgroundImageView)
        addSubview(searchBar)
        addSubview(tapButton)
        addSubview(weatherCollectionView)
        addSubview(activityIndicatorView)
    }
    
    override func configureLayout() {
        weatherBackgroundImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.height.equalTo(50)
        }
        
        tapButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.height.equalTo(50)
        }
        
        weatherCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(80)
        }
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = Color.backgroundBlue
        
        searchBar.isUserInteractionEnabled = false
        tapButton.backgroundColor = .clear
        searchBar.alpha = 0
        weatherBackgroundImageView.alpha = 0
        
        weatherCollectionView.alpha = 0
        weatherCollectionView.backgroundColor = .clear
        weatherCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        weatherCollectionView.showsVerticalScrollIndicator = false
        
        weatherCollectionView.register(CurrentWeatherHeaderCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: CurrentWeatherHeaderCollectionReusableView.identifier)  // 현재 날씨 셀의 헤더 - 지역 이름
        weatherCollectionView.register(HeaderTitleCollectionReusableView.self,
                                       forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                       withReuseIdentifier: HeaderTitleCollectionReusableView.identifier)           // 그 외 셀의 헤더 - 아이콘, 타이틀
        
        weatherCollectionView.register(CurrentWeatherCollectionViewCell.self, forCellWithReuseIdentifier: CurrentWeatherCollectionViewCell.identifier)
        weatherCollectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        weatherCollectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.identifier)
        weatherCollectionView.register(LocationMapCollectionViewCell.self, forCellWithReuseIdentifier: LocationMapCollectionViewCell.identifier)
        weatherCollectionView.register(WeatherInfoCollectionViewCell.self, forCellWithReuseIdentifier: WeatherInfoCollectionViewCell.identifier)
    }
}

extension WeatherView {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            if let weatherSection = WeatherSection(rawValue: sectionIndex) {
                let section: NSCollectionLayoutSection
                
                switch weatherSection {
                case .currentWeather:
                    section = currentWeatherLayout()
                case .hourly:
                    section = hourlyWeatherLayout()
                case .fiveDays:
                    section = fiveDaysWeatherLayout()
                case .locationMap:
                    section = locationMapLayout()
                case .humidity, .clouds, .windSpeed:
                    section = weatherInfoLayout()
                }
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16)
        
                return section
            } else {
                return nil
            }
        }
        layout.register(CellBackgroundReusableView.self, forDecorationViewOfKind: CellBackgroundReusableView.identifier)
        return layout
    }
    
    @discardableResult
    private func currentWeatherLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(24)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 3
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    @discardableResult
    private func hourlyWeatherLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(98),
                                              heightDimension: .absolute(114))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400.0),
                                               heightDimension: .estimated(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(24)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(20)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    @discardableResult
    private func fiveDaysWeatherLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(70))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(535))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(20)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
    
        return section
    }
    
    @discardableResult
    private func locationMapLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(20)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: CellBackgroundReusableView.identifier)
        section.decorationItems = [sectionBackgroundDecoration]
        return section
    }
    
    @discardableResult
    private func weatherInfoLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}
