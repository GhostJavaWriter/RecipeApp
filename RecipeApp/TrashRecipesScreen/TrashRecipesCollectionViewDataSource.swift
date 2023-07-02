//
//  TrashRecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 12.06.2023.
//

import UIKit
import CoreData

class TrashRecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var viewModel: TrashRecipesViewModel

    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    init(viewModel: TrashRecipesViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        if let recipe = viewModel.getRecipeAt(indexPath) {
            cell.setupCell(with: recipe)
        }
        
        return cell
    }

}

