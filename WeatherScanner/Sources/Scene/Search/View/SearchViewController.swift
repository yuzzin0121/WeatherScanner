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
    
    weak var sendCityDelegate: SendCityDelegate?
    
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
                                          searchButtonTap: mainView.searchBar.rx.searchButtonClicked.asObservable(), 
                                          cityCellTapped: mainView.collectionView.rx.modelSelected(City.self).asObservable())
        let output = viewModel.transform(input: input)
        
        output.cityList
            .drive(mainView.collectionView.rx.items(cellIdentifier: CityCollectionViewCell.identifier, cellType: CityCollectionViewCell.self)) { index, city, cell in
                print(city)
                cell.configureCell(city: city)
            }
            .disposed(by: disposeBag)
        
        output.cityList
            .drive(with: self) { owner, cityList in
                owner.mainView.setEmptyLabelVisible(isEmpty: cityList.isEmpty)
            }
            .disposed(by: disposeBag)
        
        output.searchResultEmpty
            .withLatestFrom(output.searchText)
            .drive(with: self) { owner, searchText in
                owner.showAlert(title: "도시 검색 결과", message: "\(searchText)와 일치하는 도시가 없습니다\n다시 검색해주세요", actionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, errorString in
                owner.showAlert(title: "도시 검색 결과", message: errorString, actionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        // 도시 선택했을 때
        output.cityCellTapped
            .drive(with: self) { owner, city in
                owner.sendCityDelegate?.sendCity(city)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
}
