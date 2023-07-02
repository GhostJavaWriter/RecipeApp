//
//  CategoriesViewModel.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.06.2023.
//

import Foundation

final class CategoriesViewModel {
    
    private let coreDataStack: CoreDataStack
    let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getNumberOfItemsInSection() -> Int {
        coreDataStack.getRecipesGroups().count
    }
    
    func getGroupAt(_ indexPath: IndexPath) -> RecipesGroup {
        
        return coreDataStack.getRecipesGroupAt(indexPath)
    }
    
    func getRecipesListViewController(recipesGroupIndexPath indexPath: IndexPath) -> RecipesListViewController {
        let currentGroup = getGroupAt(indexPath)
        let recipesListViewModel = RecipesListViewModel(coreDataStack: coreDataStack,
                                                        currentGroup: currentGroup)
        return RecipesListViewController(viewModel: recipesListViewModel)
    }
}
