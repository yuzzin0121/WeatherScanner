//
//  UIStackView+Extension.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

extension UIStackView {
    func design(axis: NSLayoutConstraint.Axis = .vertical,
                alignment: UIStackView.Alignment = .center,
                distribution: UIStackView.Distribution = .fill,
                spacing: CGFloat = 2
    ) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
