//
//  CategoriesCollectionViewDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

final class CategoriesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var navigationController: UINavigationController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipesVC = RecipesListViewController()
        navigationController?.pushViewController(recipesVC, animated: true)
    }
}
