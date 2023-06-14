//
//  RecipesDataManager.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 13.06.2023.
//

import Foundation

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
    
    private let categories = [Categories.BakingNDesserts,
                              Categories.SoupsNBroths,
                              Categories.SaladsNAppetizers,
                              Categories.MainNCourses,
                              Categories.BeveragesNCocktails,
                              Categories.SaucesNCreams]
    
    private var recipes: [RecipeModel] = []
    private var deletedRecipes: [RecipeModel] = []
    
    /// Returns the categories of recipes
    func getCategories() -> [Categories] {
        return categories
    }
    
    /// Returns the current list of recipes
    func getRecipes() -> [RecipeModel] {
        return recipes
    }
    
    /// Returns the list of deleted recipes
    func getDeletedRecipes() -> [RecipeModel] {
        return deletedRecipes
    }
    
    /// Returns the list of recipes from chosen categorie
    func getRecipesWith(_ categorie: Categories) -> [RecipeModel] {
        var recipesWithCategorie: [RecipeModel] = []
        for recipe in recipes {
            if recipe.categorie == categorie {
                recipesWithCategorie.append(recipe)
            }
        }
        return recipesWithCategorie
    }
    
    /**
         Removes a recipe from the list of current recipes and adds it to the deleted recipes.
         
         If the recipe is not found in the current list, an error message will be logged.

         - Parameter recipe: The recipe to be removed.
        */
    func removeRecipe(_ recipe: RecipeModel) {
        if let index = recipes.firstIndex(of: recipe) {
            recipes.remove(at: index)
            deletedRecipes.append(recipe)
        } else {
            NSLog("cannot find recipe", #function)
        }
    }
    
    /**
         Removes a deleted recipe from the list of deleted recipes.
         
         If the recipe is not found in the deleted list, an error message will be logged.

         - Parameter recipe: The deleted recipe to be removed.
        */
    func removeDeletedRecipe(_ recipe: RecipeModel) {
        if let index = deletedRecipes.firstIndex(of: recipe) {
            deletedRecipes.remove(at: index)
        } else {
            NSLog("cannot find recipe", #function)
        }
    }
    
    /**
         Restores a deleted recipe back to the list of current recipes.
         
         If the recipe is not found in the deleted list, an error message will be logged.

         - Parameter recipe: The recipe to be restored.
        */
    func restoreDeletedRecipe(_ recipe: RecipeModel) {
        if let index = deletedRecipes.firstIndex(of: recipe) {
            deletedRecipes.remove(at: index)
            recipes.append(recipe)
        } else {
            NSLog("cannot find recipe", #function)
        }
    }
    
    /**
         Adds a new recipe to the list of current recipes.

         This method allows you to add a new recipe to the current list.
         The new recipe will be appended to the end of the list.

         - Parameter recipe: The recipe to be added.
        */
    func addNewRecipe(_ recipe: RecipeModel) {
        recipes.append(recipe)
    }

}
