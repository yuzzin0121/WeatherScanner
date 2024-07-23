//
//  WeatherViewController.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit
import RxSwift

final class WeatherViewController: BaseViewController {
    private let mainView = WeatherView()
    
    private let viewModel: WeatherViewModel
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let input = WeatherViewModel.Input(viewDidLoadTrigger: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        
    }

    override func loadView() {
        view = mainView
    }
}
