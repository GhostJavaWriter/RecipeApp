//
//  RecipesDataManager.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 13.06.2023.
//

import UIKit
import CoreData

enum Categories: String, CaseIterable, Codable {
    
    case BakingNDesserts = "Baking\nDesserts"
    case SoupsNBroths = "Soups\nBroths"
    case SaladsNAppetizers = "Salads\nAppetizers"
    case MainNCourses = "Main\nCourses"
    case BeveragesNCocktails = "Beverages\nCocktails"
    case SaucesNCreams = "Sauces\nCreams"
}

protocol RecipesDataManaging {
    var dataManager: RecipesDataManager { get set }
}

final class RecipesDataManager {
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    func getAllRecipes() -> [Recipe] {
        
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes
        } catch {
            print("Failed to fetch recipes groups: \(error.localizedDescription)")
            return []
        }
    }
    
    func getContext() -> NSManagedObjectContext {
        return context
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch let error {
            print("Failed to save context: \(error)")
        }
    }
    
    func getDeletedRecipes() -> [Recipe] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "deletedDate != nil")
        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes
        } catch {
            print("Failed to fetch recipes groups: \(error.localizedDescription)")
            return []
        }
    }
    
    func getRecipesGroups() -> [RecipesGroup] {
        let fetchRequest: NSFetchRequest<RecipesGroup> = RecipesGroup.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(RecipesGroup.name), ascending: true)]
        do {
            let recipesGroups = try context.fetch(fetchRequest)
            return recipesGroups
        } catch {
            print("Failed to fetch recipes groups: \(error.localizedDescription)")
            return []
        }
    }
    
    func getRecipesInGroup(_ group: RecipesGroup) -> [Recipe] {
        let name = group.name!
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recipesGroup.name == %@", name)
        do {
            let recipes = try context.fetch(fetchRequest)
            return recipes
        } catch {
            print("Failed to fetch recipes groups: \(error.localizedDescription)")
            return []
        }
    }
    
    func createDefaultCategories() {
        
        let recipesGroupNames = ["Baking\nDesserts",
                                 "Soups\nBroths",
                                 "Salads\nAppetizers",
                                 "Main\nCourses",
                                 "Beverages\nCocktails",
                                 "Sauces\nCreams"]
        
        for name in recipesGroupNames {
            let group = RecipesGroup(context: context)
            group.name = name
        }
        saveContext()
    }
    
}
