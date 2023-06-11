//
//  RecipesCollectionViewFlowLayout.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

final class RecipesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        scrollDirection = .vertical
        minimumInteritemSpacing = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

