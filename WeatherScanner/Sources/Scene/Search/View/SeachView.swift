//
//  SeachView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit

final class SearchView: BaseView {
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
    }
    
    override func configureLayout() {
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}

