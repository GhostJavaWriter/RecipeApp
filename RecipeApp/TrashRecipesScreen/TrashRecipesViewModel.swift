//
//  TrashRecipesViewModel.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.06.2023.
//

import Foundation
import CoreData

final class TrashRecipesViewModel {
    
    private var coreDataStack: CoreDataStack
    private lazy var backgroundContext = coreDataStack.persistentContainer.newBackgroundContext()
    
    lazy var recipesFetchedResultsController: NSFetchedResultsController<Recipe> = {
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deletedDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "deletedDate != nil")
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: backgroundContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        return fetchResultsController
    }()
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        
        
    }
    
    // MARK: - Public methods
    
    func fetchData() throws -> [Recipe] {
        do {
            try recipesFetchedResultsController.performFetch()
            return recipesFetchedResultsController.fetchedObjects ?? []
        } catch {
            throw error
        }
    }
    
    func emptyTrash() {
        for object in recipesFetchedResultsController.fetchedObjects ?? [] {
            backgroundContext.delete(object)
        }
        coreDataStack.saveContextIfHasChanges(backgroundContext)
    }
    
    func getNumberOfItemsInSection() -> Int {
        recipesFetchedResultsController.fetchedObjects?.count ?? .zero
    }
    
    func getRecipeAt(_ indexPath: IndexPath) -> Recipe? {
        return recipesFetchedResultsController.object(at: indexPath)
    }
    
    func restoreRecipeAt(_ indexPath: IndexPath) {
        
        let object = recipesFetchedResultsController.object(at: indexPath)
        object.deletedDate = nil
        coreDataStack.saveContextIfHasChanges(backgroundContext)
    }
}
