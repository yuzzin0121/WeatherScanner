//
//  City.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let country: String
    let coord: Coord
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}
