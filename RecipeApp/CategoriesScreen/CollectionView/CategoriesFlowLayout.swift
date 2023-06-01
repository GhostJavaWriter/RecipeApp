//
//  CategoriesFlowLayout.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

final class CategoriesFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        scrollDirection = .vertical
        minimumLineSpacing = Metrics.CategorieItem.minimumLineSpacing
        minimumInteritemSpacing = Metrics.CategorieItem.minimumInteritemSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
