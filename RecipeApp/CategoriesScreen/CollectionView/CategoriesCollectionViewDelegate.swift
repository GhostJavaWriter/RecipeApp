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
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let originalTransform = cell.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.95, y: 0.95)
        
        cell.transform = scaledTransform
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = originalTransform
        }, completion: nil)
        
        let recipesVC = RecipesListViewController()
        navigationController?.pushViewController(recipesVC, animated: true)
    }
}
