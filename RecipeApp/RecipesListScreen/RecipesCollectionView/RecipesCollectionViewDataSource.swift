//
//  RecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

class RecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let dataManager: RecipesDataManager
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    init(dataManager: RecipesDataManager) {
        self.dataManager = dataManager
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        cell.configureCell(withText: recipesList[indexPath.item]) 
        
        return cell
    }
}
