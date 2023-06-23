//
//  CoreDataStack.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 22.06.2023.
//

import CoreData

final class CoreDataStack {
    
    private(set) var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var recipesGroups: [RecipesGroup] = {
        let fetchRequest: NSFetchRequest<RecipesGroup> = RecipesGroup.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(RecipesGroup.name), ascending: true)]
        do {
            let recipesGroups = try mainContext.fetch(fetchRequest)
            return recipesGroups
        } catch {
            print("Failed to fetch recipes groups: \(error.localizedDescription)")
            return []
        }
    }()
    
    /// Create default categories
    func createDefaultCategories() {
        let recipesGroupNames = ["Baking\nDesserts",
                                 "Soups\nBroths",
                                 "Salads\nAppetizers",
                                 "Main\nCourses",
                                 "Beverages\nCocktails",
                                 "Sauces\nCreams"]
        
        for name in recipesGroupNames {
            let group = RecipesGroup(context: mainContext)
            group.name = name
        }
        saveContext()
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
    func saveContext () {
        
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    /// Empty recipes in trash that older than 30 days
    func emptyTrash() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        if let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) as? NSDate {
            fetchRequest.predicate = NSPredicate(format: "deletedDate <= %@", thirtyDaysAgo)
            
            do {
                let recipes = try mainContext.fetch(fetchRequest)
                for recipe in recipes {
                    mainContext.delete(recipe)
                }
                saveContext()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else {
            NSLog("NSDate error \(#function)")
        }
    }

}
