//
//  ViewProtocol.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

protocol ViewProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}
