//
//  WeatherInfoCollectionViewCell.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

final class WeatherInfoCollectionViewCell: BaseCollectionViewCell {
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    let headerLabel = UILabel()
    let valueLabel = UILabel()
    let subValueLabel = UILabel()
    
    func configureCell(title: String, infoValue: [Double]) {
        headerLabel.text = title
        
        let value = infoValue[0]
        switch infoValue.count {
        case 1:
            valueLabel.text = "\(Int(value))%"
        case 2:
            valueLabel.text = "\(value)m/s"
            subValueLabel.text = "강풍: \(infoValue[1])m/s"
        default:
            break
        }
    }
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
        addSubview(headerLabel)
        addSubview(valueLabel)
        addSubview(subValueLabel)
    }
    
    override func configureLayout() {
        visualEffectView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
        headerLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(6)
        }
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(14)
        }
        
        subValueLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(6)
        }
    }
    
    override func configureView() {
        headerLabel.design(font: .systemFont(ofSize: 14, weight: .regular))
        valueLabel.design(font: .boldSystemFont(ofSize: 26), numberOfLines: 2)
        subValueLabel.design(textColor: .lightGray, textAlignment: .left)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.clipsToBounds = true
    }
}
