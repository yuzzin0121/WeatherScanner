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
    
    static func formattedNumberString(_ value: Double) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        if let formattedNumber = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedNumber
        }
        return nil
    }
}
