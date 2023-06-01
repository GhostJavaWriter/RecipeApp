//
//  CategoriesCollectionView.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

final class CategoriesCollectionView: UICollectionView {
    
    private let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)
    private let layout = CategoriesFlowLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = frame.size.width * Metrics.CategorieItem.itemSizeScale
        layout.itemSize = CGSize(width: width, height: width)

    }
}
