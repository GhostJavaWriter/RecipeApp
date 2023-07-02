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
    
    func saveRecipeWith(newName: String?, newIndgredients: String?, newMethod: String?, link: String?) {
        
        guard let name = newName,
              let ingedients = newIndgredients,
              let method = newMethod
        else {
            NSLog("empty recipe fields \(#function)")
            return
        }
        
        var recipe: Recipe?
        
        switch mode {
        case .newRecipe:
            recipe = Recipe(context: coreDataStack.viewContext)
            recipe?.recipesGroup = currentGroup
            recipe?.id = UUID().uuidString
        case .view:
            recipe = currentRecipe
        }
        
        if let link = link,
           let url = URL(string: link),
           UIApplication.shared.canOpenURL(url) {
            recipe?.link = link
        }
        recipe?.name = name
        recipe?.ingredients = ingedients
        recipe?.cookMethod = method
       
        coreDataStack.saveViewContext()
    }
    
    func shareRecipe() {
        
    }
    
}
