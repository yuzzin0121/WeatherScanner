//
//  CellBackgroundReusableView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

final class CellBackgroundReusableView: BaseCollectionReusableView {
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
    }
    
    override func configureLayout() {
        visualEffectView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
}
