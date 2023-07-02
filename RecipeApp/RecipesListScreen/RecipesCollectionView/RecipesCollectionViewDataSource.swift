//
//  RecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit
import CoreData

class RecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var viewModel: RecipesListViewModel
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    init(viewModel: RecipesListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        let recipeModel = viewModel.getRecipeAt(indexPath)
        cell.setupCell(with: recipeModel)
        
        return cell
    }
}
