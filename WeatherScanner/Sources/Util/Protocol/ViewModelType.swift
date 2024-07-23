//
//  ViewModelType.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
    
}
