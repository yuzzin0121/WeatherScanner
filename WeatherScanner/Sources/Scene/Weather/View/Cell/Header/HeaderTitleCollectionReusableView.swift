//
//  HeaderTitleCollectionReusableView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

final class HeaderTitleCollectionReusableView: BaseCollectionReusableView {
    let stackView = UIStackView()
    let titleLabel = UILabel()
    
    func configureHeader(title: String) {
        titleLabel.text = title
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        titleLabel.design(textColor: Color.white, font: .systemFont(ofSize: 12, weight: .regular))
    }
}
