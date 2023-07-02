//
//  RecipesListViewModel.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 2.07.2023.
//

import CoreData
import UIKit

final class RecipesListViewModel {
    
    // MARK: - Properties
    
    private var coreDataStack: CoreDataStack
    let currentGroupName: String
    
    private(set) lazy var fetchedResultsController: NSFetchedResultsController<Recipe> = {
        let mainContext = coreDataStack.viewContext
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Recipe.name), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "recipesGroup.name == %@ AND deletedDate == nil", currentGroupName)
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: mainContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        return fetchResultsController
    }()
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack, currentGroupName: String) {
        self.coreDataStack = coreDataStack
        self.currentGroupName = currentGroupName
    }
    
    // MARK: - Private methods
    
    func getNumberOfItemsInSection() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? .zero
    }
    
    func getRecipeAt(_ indexPath: IndexPath) -> Recipe? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func fetchData() throws {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            throw error
        }
    }
    
    func getTrashRecipesViewController() -> TrashRecipesViewController {
        let viewModel = TrashRecipesViewModel(coreDataStack: coreDataStack)
        let trashRecipesVC = TrashRecipesViewController(viewModel: viewModel)
        return trashRecipesVC
    }
    
    func handleDrop(session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { [weak self] recipes in
            guard let self = self else { return }
            if let recipe = recipes.first as? String {
                
                coreDataStack.persistentContainer.performBackgroundTask { _ in
                    let recipeWithName = self.fetchedResultsController.fetchedObjects?.first {$0.name == recipe}
                    recipeWithName?.deletedDate = Date()
                    DispatchQueue.main.async {
                        self.coreDataStack.saveViewContext()
                    }
                }
            } else {
                NSLog("recipe error", #function)
            }
        }
    }
}
