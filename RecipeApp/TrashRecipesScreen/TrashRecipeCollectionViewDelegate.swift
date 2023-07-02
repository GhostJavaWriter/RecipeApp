//
//  TrashRecipeCollectionViewDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 12.06.2023.
//

import UIKit
import CoreData

final class TrashRecipeCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var viewModel: TrashRecipesViewModel
    
    init(viewModel: TrashRecipesViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let originalTransform = cell.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.95, y: 0.95)
        
        cell.transform = scaledTransform
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = originalTransform
        }, completion: nil)
        
        // TODO: show recipe details (RecipeViewController)
//        let recipeVC = RecipeViewController(mode: .view, coreDataStack: coreDataStack, currentGroup: <#T##RecipesGroup#>)
//        navigationContoller?.pushViewController(recipeVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height / 15
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { _ in
            
            let indexPath = indexPaths[0]
            
            if let recipe = self.viewModel.getRecipeAt(indexPath) {
                
                let restore = UIAction(title: "\(recipe.name!)", image: UIImage(systemName: "arrowshape.turn.up.left")) { action in
                    
                    self.viewModel.restoreRecipeAt(indexPath)
                }
                return UIMenu(title: "Restore recipe", children: [restore])
            }
            return UIMenu()
        })
    }
}

