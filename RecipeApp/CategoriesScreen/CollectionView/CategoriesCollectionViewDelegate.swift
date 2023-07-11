//
//  CategoriesCollectionViewDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 2.07.2023.
//

import UIKit

final class CategoriesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    private let viewModel: CategoriesViewModel
    private let navigationController: UINavigationController?
    
    init(viewModel: CategoriesViewModel, navigationController: UINavigationController?) {
        self.viewModel = viewModel
        self.navigationController = navigationController
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        animateCellSelection(for: cell)
        
        let recipesVC = viewModel.getRecipesListViewController(recipesGroupIndexPath: indexPath)
        navigationController?.pushViewController(recipesVC, animated: true)
    }
    
    private func animateCellSelection(for cell: UICollectionViewCell) {
        let originalTransform = cell.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.95, y: 0.95)
        
        cell.transform = scaledTransform
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = originalTransform
        }, completion: nil)
    }
}
