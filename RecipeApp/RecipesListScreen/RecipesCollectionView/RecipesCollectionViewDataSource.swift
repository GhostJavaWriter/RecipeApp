//
//  RecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

class RecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var recipesList: [String] = []

    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        cell.configureCell(withText: recipesList[indexPath.item]) 
        
        return cell
    }
}
