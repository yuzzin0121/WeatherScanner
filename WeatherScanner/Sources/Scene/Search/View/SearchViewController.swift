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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.setFirstResponder()
    }
    
    override func bind() {
        let input = SearchViewModel.Input(searchText: mainView.searchBar.rx.text.orEmpty.asObservable(),
                                          searchButtonTap: mainView.searchBar.rx.searchButtonClicked.asObservable())
        let output = viewModel.transform(input: input)
        
        output.cityList
            .drive(mainView.collectionView.rx.items(cellIdentifier: CityCollectionViewCell.identifier, cellType: CityCollectionViewCell.self)) { index, city, cell in
                print(city)
                cell.configureCell(city: city)
            }
            .disposed(by: disposeBag)
        

    }

    override func loadView() {
        view = mainView
    }
}
