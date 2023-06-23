//
//  CategoriesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

class CategoriesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var coreDataStack: CoreDataStack
    private let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coreDataStack.getRecipesGroups().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        
        let recipesGroups = coreDataStack.getRecipesGroups()
        cell.categoryNameLabel.text = recipesGroups[indexPath.item].name
        
        return cell
    }
}

