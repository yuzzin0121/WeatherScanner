//
//  BaseView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit

class BaseView: UIView, ViewProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        
    }
    func configureLayout() {
        
    }
    func configureView() {
        backgroundColor = Color.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
