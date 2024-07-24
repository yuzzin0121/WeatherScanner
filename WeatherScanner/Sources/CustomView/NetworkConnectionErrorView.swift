//
//  NetworkConnectionErrorView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit
import SnapKit

final class NetworkConnectionErrorView: BaseView {
    let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(stackView)
        [imageView, titleLabel, descriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(23)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(-14)
            make.centerX.equalToSuperview()
            make.size.equalTo(126)
        }
    }
    
    override func configureView() {
        self.backgroundColor = Color.white.withAlphaComponent(0.95)
        
        stackView.design(axis: .vertical, alignment: .center, spacing: 16)

        imageView.image = Image.cloudOff
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.design(text: "앗! 오프라인 상태인 것 같아요", textColor: Color.textBlack, font: .systemFont(ofSize: 18, weight: .semibold), textAlignment: .center)
        descriptionLabel.design(text: "WeatherScanner을 이용하려면\nWi-Fi 혹은 데이터 네트워크 연결이 필요해요", textColor: Color.textGray, font: .systemFont(ofSize: 16, weight: .regular), textAlignment: .center, numberOfLines: 2)
        descriptionLabel.setLineSpacing(spacing: 10)
        descriptionLabel.textAlignment = .center
    }
}
