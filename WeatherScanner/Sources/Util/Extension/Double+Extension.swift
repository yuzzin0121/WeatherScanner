//
//  Double+Extension.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation

extension Double {
    func kelvinToCelsius() -> Int {
        return Int(self - 273.15)
    }
}
