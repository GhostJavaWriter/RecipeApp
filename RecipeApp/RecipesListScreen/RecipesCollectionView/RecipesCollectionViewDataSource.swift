//
//  RecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

class RecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let dataManager: RecipesDataManager
    private let currentCategorie: RecipesGroup
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    private lazy var recipes: [Recipe] = {
        return dataManager.getRecipesInGroup(currentCategorie)
    }()
    
    init(dataManager: RecipesDataManager, categorie: RecipesGroup) {
        self.dataManager = dataManager
        self.currentCategorie = categorie
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        let recipeModel = recipes[indexPath.row]
        cell.setupCell(with: recipeModel)
        
        return cell
    }
}
