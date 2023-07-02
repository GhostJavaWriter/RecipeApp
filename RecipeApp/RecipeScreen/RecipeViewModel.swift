//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 2.07.2023.
//

import UIKit

enum RecipeViewControllerMode {
    case view
    case newRecipe
}

final class RecipeViewModel {
    
    private var coreDataStack: CoreDataStack
    let currentRecipe: Recipe?
    let currentGroup: RecipesGroup?
    let mode: RecipeViewControllerMode
    
    init(coreDataStack: CoreDataStack, mode: RecipeViewControllerMode, currentRecipe: Recipe?, currentGroup: RecipesGroup?) {
        
        self.coreDataStack = coreDataStack
        self.mode = mode
        self.currentRecipe = currentRecipe
        self.currentGroup = currentGroup
    }
    
    func saveChanges(newName: String?, newIndgredients: String?, newMethod: String?, link: String?) {
        guard let name = newName,
              let ingedients = newIndgredients,
              let method = newMethod
        else {
            return
        }
        if let link = link,
           let url = URL(string: link),
           UIApplication.shared.canOpenURL(url) {
            currentRecipe?.link = link
        }
        currentRecipe?.name = name
        currentRecipe?.ingredients = ingedients
        currentRecipe?.cookMethod = method
       
        coreDataStack.saveViewContext()
    }
    
    func createNewRecipeWith(name: String?, ingredients: String?, method: String?, link: String?) {
        
        let newRecipe = Recipe(context: coreDataStack.viewContext)
        
        guard let name = name,
              let ingredients = ingredients,
              let method = method
        else {
            return
        }
        
        if let link = link,
           let url = URL(string: link),
           UIApplication.shared.canOpenURL(url) {
            newRecipe.link = link
        }
        
        newRecipe.id = UUID().uuidString
        newRecipe.name = name
        newRecipe.ingredients = ingredients
        newRecipe.cookMethod = method
        currentGroup?.addToRecipes(newRecipe)
        
        coreDataStack.saveViewContext()
    }
}
