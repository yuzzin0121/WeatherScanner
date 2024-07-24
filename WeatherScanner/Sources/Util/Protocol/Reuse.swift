//
//  Reuse.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import UIKit

protocol Reuse: AnyObject {
    static var identifier: String { get }
}

extension UICollectionReusableView: Reuse {
    static var identifier: String {
        String(describing: self)
    }
}
