//
//  SeachView.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/23/24.
//

import UIKit

final class SearchView: BaseView {
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    let searchBar = SearchBar(placeholder: "도시 이름 검색")
    let emptyMessageLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    func setSearchBarTextEmpty(isEmpty: Bool) {
        if isEmpty {
            searchBar.text = ""
        }
    }
    
    func setEmptyLabelVisible(isEmpty: Bool) {
        emptyMessageLabel.isHidden = !isEmpty
    }
    
    func setFirstResponder() {
        searchBar.becomeFirstResponder()
    }
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(emptyMessageLabel)
    }
    
    override func configureLayout() {
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        emptyMessageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        collectionView.keyboardDismissMode = .onDrag    // 키보드 드래그 시 dismiss
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        
        emptyMessageLabel.design(text: "현재 일치하는 도시가 없습니다\n 다시 검색해주세요", textColor: Color.backgroundGray, font: .systemFont(ofSize: 16, weight: .semibold), numberOfLines: 2)
        
        emptyMessageLabel.setLineSpacing(spacing: 8)
        emptyMessageLabel.textAlignment = .center
    }
}

extension SearchView {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        return layout
    }
}

