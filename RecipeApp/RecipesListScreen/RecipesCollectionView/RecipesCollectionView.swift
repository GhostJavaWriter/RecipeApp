//
//  RecipesCollectionView.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

final class RecipesCollectionView: UICollectionView {
    
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    private let layout = RecipesCollectionViewFlowLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        translatesAutoresizingMaskIntoConstraints = false
        register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
