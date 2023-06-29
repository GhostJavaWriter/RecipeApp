//
//  TrashRecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 12.06.2023.
//

import UIKit
import CoreData

class TrashRecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var fetchedResultsController: NSFetchedResultsController<Recipe>!

    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        if let recipe = fetchedResultsController.fetchedObjects?[indexPath.row] {
            cell.setupCell(with: recipe)
        }
        
        return cell
    }

}

