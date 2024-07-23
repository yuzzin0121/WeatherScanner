//
//  CurrentWeatherCollectionViewCell.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

// 현재 날씨 셀
final class CurrentWeatherCollectionViewCell: BaseCollectionViewCell {
    let stackView = UIStackView()
    let tempLabel = UILabel()
    let descriptionLabel = UILabel()
    let tempDetailLabel = UILabel()     // tempMin, tempMax
    
    func configureCell(currentWeather: CurrentWeather) {
        tempLabel.text = "\(currentWeather.temp)º"
        descriptionLabel.text = currentWeather.weather
        tempDetailLabel.text = "최고:\(currentWeather.tempMax)º | 최저:\(currentWeather.tempMin)º"
    }
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        [tempLabel, descriptionLabel, tempDetailLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        stackView.design()
        tempLabel.design(font: .systemFont(ofSize: 36, weight: .bold), textAlignment: .center)
        descriptionLabel.design(font: .systemFont(ofSize: 24, weight: .semibold), textAlignment: .center)
        tempDetailLabel.design(font: .systemFont(ofSize: 16, weight: .semibold), textAlignment: .center)
    }
}
