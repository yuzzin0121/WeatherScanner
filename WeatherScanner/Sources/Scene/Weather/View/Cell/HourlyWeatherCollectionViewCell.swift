//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

// 시간별 날씨 셀
final class HourlyWeatherCollectionViewCell: BaseCollectionViewCell {
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let stackView = UIStackView()
    let timeLabel = UILabel()
    let weatherImageView = UIImageView()
    let tempLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = nil
    }
    
    func configureCell(hourlyWeatherData: HourlyWeather) {
        timeLabel.text = hourlyWeatherData.time
        weatherImageView.image = (UIImage(named: hourlyWeatherData.icon))
        tempLabel.text = "\(hourlyWeatherData.temp)º"
    }
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
        addSubview(stackView)
        [timeLabel, weatherImageView, tempLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        visualEffectView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    override func configureView() {
        visualEffectView.layer.masksToBounds = true
        
        stackView.design()
        timeLabel.design(font: .systemFont(ofSize: 14, weight: .semibold),
                         textAlignment: .center)
        weatherImageView.contentMode = .scaleAspectFit
        tempLabel.design(font: .boldSystemFont(ofSize: 17),
                         textAlignment: .center)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        visualEffectView.layer.cornerRadius = visualEffectView.frame.height / 3
    }
}
