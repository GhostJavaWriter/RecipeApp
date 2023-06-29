//
//  CoreDataStack.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 22.06.2023.
//

import CoreData

final class CoreDataStack {
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        loadPersistentStoreFor(container)
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var recipesGroups: [RecipesGroup] = fetchRecipesGroups()
    
    /// Create default categories
    func createDefaultCategories() {
        let recipesGroupNames = ["Baking\nDesserts",
                                 "Soups\nBroths",
                                 "Salads\nAppetizers",
                                 "Main\nCourses",
                                 "Beverages\nCocktails",
                                 "Sauces\nCreams"]
        
        recipesGroupNames.forEach { createCategory(named: $0) }
        saveContextIfHasChanges()
    }
    
    /// Return pre-setted recipes groups or empty array if error occurs
    func getRecipesGroups() -> [RecipesGroup] {
        return recipesGroups
    }
    
    /// Return recipes group at indexPath
    func getRecipesGroupAt(_ indexPath: IndexPath) -> RecipesGroup {
        return recipesGroups[indexPath.row]
    }
    
    /// Save main context
    func saveContextIfHasChanges() {
        guard mainContext.hasChanges else { return }
        
        do {
            try mainContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func saveContextIfHasChanges(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    /// Empty recipes in trash that older than 30 days
    func emptyTrash() {
        guard let thirtyDaysAgo = Calendar.current.date(byAdding: .day,
                                                        value: -30,
                                                        to: Date()) as NSDate?
        else {
            NSLog("NSDate error \(#function)")
            return
        }
        
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate <= %@", thirtyDaysAgo)
        deleteRecipes(with: fetchRequest)
    }
}

// MARK: - private methods

private extension CoreDataStack {
    
    func fetchRecipesGroups() -> [RecipesGroup] {
        let fetchRequest: NSFetchRequest<RecipesGroup> = RecipesGroup.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(RecipesGroup.name), ascending: true)]
        return (try? mainContext.fetch(fetchRequest)) ?? []
    }
    
    func loadPersistentStoreFor(_ container: NSPersistentContainer) {
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func createCategory(named name: String) {
        let group = RecipesGroup(context: mainContext)
        group.name = name
    }
    
    func deleteRecipes(with fetchRequest: NSFetchRequest<Recipe>) {
        do {
            let oldRecipes = try mainContext.fetch(fetchRequest)
            oldRecipes.forEach { mainContext.delete($0) }
            saveContextIfHasChanges()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
