//
//  CurrentWeatherHeaderCollectionReusableView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

final class CurrentWeatherHeaderCollectionReusableView: BaseCollectionReusableView {
    let locationNameLabel = UILabel()
    
    func configureHeader(locationName: String) {
        locationNameLabel.text = locationName
    }
    
    override func configureHierarchy() {
        addSubview(locationNameLabel)
    }
    
    override func configureLayout() {
        locationNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        locationNameLabel.design(font: .systemFont(ofSize: 24, weight: .semibold))
    }
}
