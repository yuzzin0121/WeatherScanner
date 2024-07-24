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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubview(visualEffectView)
        addSubview(searchBar)
        addSubview(collectionView)
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
    }
    
    override func configureView() {
        collectionView.backgroundColor = .clear
    }
}

extension SearchView {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
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

