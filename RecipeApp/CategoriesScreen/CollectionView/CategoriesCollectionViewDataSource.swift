//
//  CategoriesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

class CategoriesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var dataManager: RecipesDataManager
    private let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)
    
    init(dataManager: RecipesDataManager) {
        self.dataManager = dataManager
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.getCategories().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        
        let categories = dataManager.getCategories()
        cell.categoryNameLabel.text = categories[indexPath.item].rawValue
        
        return cell
    }
}

