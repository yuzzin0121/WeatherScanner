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
    }
    
    struct Output {
        let cityList: Driver<[City]>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let cityListRelay = PublishRelay<[City]>()
        let searchStringValid = BehaviorRelay(value: false)
        let errorMessage = PublishRelay<String>()
        
        input.searchText
            .map {
                let text = $0.trimmingCharacters(in: [" "])
                return text.count >= 2
            }
            .bind { isValid in
                searchStringValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
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
                    print(cityList)
                    cityListRelay.accept(cityList)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
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
        
        return Output(cityList: cityListRelay.asDriver(onErrorJustReturn: []),
                      errorMessage: errorMessage.asDriver(onErrorDriveWith: .empty()))
    }
}
