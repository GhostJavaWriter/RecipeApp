//
//  CategoriesCollectionView.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

final class CategoriesCollectionView: UICollectionView {
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Metrics.CategorieItem.minimumLineSpacing
        layout.minimumInteritemSpacing = Metrics.CategorieItem.minimumInteritemSpacing
        return layout
    }()
    
    private lazy var itemWidth = frame.size.width * Metrics.CategorieItem.itemSizeScale
    
    init(reuseIdentifier: String) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        
        register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        showsVerticalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setItemSize()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func setItemSize() {
        
        switch UIScreen.main.bounds.height {
        
        case 667.0: // iPhone 6,6s,7,8,SE (2nd generation)
            itemWidth = frame.size.width * 0.45
        default:
            itemWidth = frame.size.width * Metrics.CategorieItem.itemSizeScale
        }

    }
}
