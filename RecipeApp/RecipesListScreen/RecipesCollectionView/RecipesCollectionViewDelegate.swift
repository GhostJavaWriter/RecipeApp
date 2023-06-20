//
//  RecipesCollectionViewDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit
import CoreData

final class RecipesCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var navigationController: UINavigationController?
    var dataManager: RecipesDataManager!
    var currentGroup: RecipesGroup!
    var fetchedResultsController: NSFetchedResultsController<Recipe>!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let originalTransform = cell.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.95, y: 0.95)
        
        cell.transform = scaledTransform
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = originalTransform
        }, completion: nil)
        
        
        let recipesVC = RecipeViewController(mode: .view, dataManager: dataManager, currentGroup: currentGroup)
        recipesVC.configureRecipe(withModel: fetchedResultsController.object(at: indexPath))
        navigationController?.pushViewController(recipesVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height / 15
        
        return CGSize(width: width, height: height)
    }
}
