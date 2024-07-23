//
//  DailyWeatherCollectionViewCell.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

final class DailyWeatherCollectionViewCell: BaseCollectionViewCell {
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let backgroundStackView = UIStackView()
    let dayLabel = UILabel()
    let weatherImageView = UIImageView()
    let tempStackView = UIStackView()
    let tempMinLabel = UILabel()
    let tempMaxLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = nil
    }
    
    func configureCell(dailyWeather: DailyWeather) {
        dayLabel.text = dailyWeather.dt
        weatherImageView.image = UIImage(named: dailyWeather.icon)
        tempMinLabel.text = "최소:\(dailyWeather.tempMin)º"
        tempMaxLabel.text = "최대:\(dailyWeather.tempMax)º"
    }
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
        addSubview(backgroundStackView)
        [tempMinLabel, tempMaxLabel].forEach {
            tempStackView.addArrangedSubview($0)
        }
        
        [dayLabel, weatherImageView, tempStackView].forEach {
            backgroundStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        visualEffectView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        backgroundStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(14)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    override func configureView() {
        visualEffectView.layer.masksToBounds = true
        weatherImageView.contentMode = .scaleAspectFit
        backgroundStackView.design(axis: .horizontal, distribution: .equalCentering)
        tempStackView.design(axis: .horizontal, alignment: .fill, spacing: 12)
        dayLabel.design(font: .systemFont(ofSize: 16, weight: .semibold))
        tempMinLabel.design(font: .systemFont(ofSize: 14, weight: .semibold))
        tempMaxLabel.design(font: .systemFont(ofSize: 14, weight: .semibold))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        visualEffectView.layer.cornerRadius = visualEffectView.frame.height / 3
    }
}
