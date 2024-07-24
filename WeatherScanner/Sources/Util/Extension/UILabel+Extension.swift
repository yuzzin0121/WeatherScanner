//
//  UILabel+Extension.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

extension UILabel {
    func design(text: String = "",
                textColor: UIColor = Color.white,
                font: UIFont = .systemFont(ofSize: 14, weight: .regular),
                textAlignment: NSTextAlignment = .center,
                numberOfLines: Int = 1) {
        self.text = text
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
    
}
