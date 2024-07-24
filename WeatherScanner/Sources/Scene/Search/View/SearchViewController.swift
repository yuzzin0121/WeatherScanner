//
//  SearchViewController.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit

final class SearchViewController: BaseViewController {
    let mainView = SearchView()
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        
    }

    override func loadView() {
        view = mainView
    }
}
