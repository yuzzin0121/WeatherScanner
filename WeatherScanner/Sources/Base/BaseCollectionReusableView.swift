//
//  BaseCollectionReusableView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit
import SnapKit

class BaseCollectionReusableView: UICollectionReusableView, ViewProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
}
