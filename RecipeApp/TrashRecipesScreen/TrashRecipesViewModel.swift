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
    
    private(set) lazy var fetchedResultsController: NSFetchedResultsController<Recipe> = {
        let viewContext = coreDataStack.viewContext
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deletedDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "deletedDate != nil")
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: viewContext,
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
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects ?? []
        } catch {
            throw error
        }
    }
    
    func emptyTrash() {
        for object in fetchedResultsController.fetchedObjects ?? [] {
            coreDataStack.viewContext.delete(object)
        }
        coreDataStack.saveViewContext()
    }
    
    func getNumberOfItemsInSection() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? .zero
    }
    
    func getRecipeAt(_ indexPath: IndexPath) -> Recipe? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func restoreRecipeAt(_ indexPath: IndexPath) {
        
        let object = fetchedResultsController.object(at: indexPath)
        object.deletedDate = nil
        coreDataStack.saveViewContext()
    }
}
