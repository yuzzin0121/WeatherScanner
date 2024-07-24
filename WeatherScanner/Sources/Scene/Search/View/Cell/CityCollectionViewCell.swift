//
//  CityCollectionViewCell.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

final class CityCollectionViewCell: BaseCollectionViewCell {
    let stackView = UIStackView()
    let cityNameLabel = UILabel()
    let countryLabel = UILabel()
    
    func configureCell(city: City) {
        cityNameLabel.text = city.name
        countryLabel.text = city.country
    }
    
    override func configureHierarchy() {
        contentView.addSubview(stackView)
        [cityNameLabel, countryLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        stackView.design(alignment: .fill, spacing: 6)
        cityNameLabel.design(font: .boldSystemFont(ofSize: 18), textAlignment: .left)
        countryLabel.design(textColor: Color.backgroundGray, font: .systemFont(ofSize: 15, weight: .light), textAlignment: .left)
    }
}
