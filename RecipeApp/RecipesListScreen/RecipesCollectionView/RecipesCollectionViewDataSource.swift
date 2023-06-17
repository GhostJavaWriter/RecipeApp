//
//  RecipesCollectionViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit
import CoreData

class RecipesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var fetchedResultsController: NSFetchedResultsController<Recipe>
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    init(fetchedResultsController: NSFetchedResultsController<Recipe>) {
        self.fetchedResultsController = fetchedResultsController
        
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell()}
        
        let recipeModel = fetchedResultsController.object(at: indexPath)
        cell.setupCell(with: recipeModel)
        
        return cell
    }
}
