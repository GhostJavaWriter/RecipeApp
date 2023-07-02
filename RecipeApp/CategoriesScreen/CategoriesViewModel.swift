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
    
    func getGroupNameAt(_ indexPath: IndexPath) -> String {
        
        if let groupName = coreDataStack.getRecipesGroupAt(indexPath).name {
            return groupName
        } else {
            NSLog("group name error, \(#function)")
            return "error"
        }
    }
    
    func getRecipesListViewController(recipesGroupIndexPath indexPath: IndexPath) -> RecipesListViewController {
        let currentGroupName = getGroupNameAt(indexPath)
        let recipesListViewModel = RecipesListViewModel(coreDataStack: coreDataStack,
                                                        currentGroupName: currentGroupName)
        return RecipesListViewController(viewModel: recipesListViewModel)
    }
}
