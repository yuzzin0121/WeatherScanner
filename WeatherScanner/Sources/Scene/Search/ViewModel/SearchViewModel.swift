//
//  SearchViewModel.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let searchText: Observable<String>
        let searchButtonTap: Observable<Void>
        let cityCellTapped: Observable<City>
    }
    
    struct Output {
        let cityList: Driver<[City]>
        let searchText: Driver<String>
        let searchResultEmpty: Driver<Void>
        let cityCellTapped: Driver<City>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let cityListRelay = PublishRelay<[City]>()
        let searchText = PublishRelay<String>()
        let searchStringValid = BehaviorRelay(value: false)
        let searchResultEmpty = PublishRelay<Void>()
        let cityCellTapped = PublishRelay<City>()
        let errorMessage = PublishRelay<String>()
        
        input.searchText
            .map {
                let text = $0.trimmingCharacters(in: [" "])
                searchText.accept(text)
                return text.count >= 0
            }
            .bind { isValid in
                searchStringValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { text in
                if searchStringValid.value == true {
                    return CityManager.shared.searchCity(name: text)
                } else {
                    return Single<Result<[City], Error>>.never()
                }
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let cityList):
                    cityListRelay.accept(cityList)

                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .flatMap { text in
                print(text)
                if searchStringValid.value == true {
                    return CityManager.shared.searchCity(name: text)
                } else {
                    return Single<Result<[City], Error>>.never()
                }
            }
            .bind(with: self, onNext: { owner, result in
                switch result {
                case .success(let cityList):
                    print(cityList)
                    if cityList.isEmpty {
                        searchResultEmpty.accept(())
                    }
                    cityListRelay.accept(cityList)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        input.cityCellTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { city in
                cityCellTapped.accept(city)
            }  
            .disposed(by: disposeBag)
        
        return Output(cityList: cityListRelay.asDriver(onErrorJustReturn: []),
                      searchText: searchText.asDriver(onErrorDriveWith: .empty()),
                      searchResultEmpty: searchResultEmpty.asDriver(onErrorDriveWith: .empty()), 
                      cityCellTapped: cityCellTapped.asDriver(onErrorDriveWith: .empty()),
                      errorMessage: errorMessage.asDriver(onErrorDriveWith: .empty()))
    }
}
