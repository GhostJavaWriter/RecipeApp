//
//  CategoriesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

class CategoriesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let categories = ["Baking\nDesserts",
                              "Soups\nBroths",
                              "Salads\nAppetizers",
                              "Main\nCourses",
                              "Beverages\nCocktails",
                              "Sauces\nCreams"]

    private let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}
        
        cell.categoryNameLabel.text = categories[indexPath.item]
        
        return cell
    }
}

