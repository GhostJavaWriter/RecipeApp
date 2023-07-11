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
    let type: RecipeViewControllerMode
    
    init(coreDataStack: CoreDataStack, type: RecipeViewControllerMode, currentRecipe: Recipe?, currentGroup: RecipesGroup?) {
        
        self.coreDataStack = coreDataStack
        self.type = type
        self.currentRecipe = currentRecipe
        self.currentGroup = currentGroup
    }
    
    func saveRecipeWith(recipeFieldsDataModel: RecipeFieldsDataModel) {
        
        guard let name = recipeFieldsDataModel.name,
              let ingedients = recipeFieldsDataModel.ingredients,
              let method = recipeFieldsDataModel.method
        else {
            NSLog("empty recipe fields \(#function)")
            return
        }
        
        var recipe: Recipe?
        
        switch type {
        case .newRecipe:
            recipe = Recipe(context: coreDataStack.viewContext)
            recipe?.recipesGroup = currentGroup
            recipe?.id = UUID().uuidString
        case .view:
            recipe = currentRecipe
        }
        
        if let link = recipeFieldsDataModel.link,
           let url = URL(string: link),
           UIApplication.shared.canOpenURL(url) {
            recipe?.link = link
        }
        recipe?.name = name
        recipe?.ingredients = ingedients
        recipe?.cookMethod = method
       
        coreDataStack.saveViewContext()
    }
    
    func setupRecipeDataForShare(recipeFieldsDataModel: RecipeFieldsDataModel) -> String {
        let recipeName = recipeFieldsDataModel.name ?? "-"
        let ingredients = recipeFieldsDataModel.ingredients ?? "-"
        let method = recipeFieldsDataModel.method ?? "-"
        
        var shareText = "Recipe Name: \(recipeName)\nIngredients: \(ingredients)\nMethod:\(method)"
        
        if let link = recipeFieldsDataModel.link {
            shareText = shareText + "\nLink: \(link)"
        }
        return shareText
    }
    
    /// This method checks recipe fields
    ///  If they are valid returns true otherwise false
    func recipeFieldsIsValid(recipeFieldsDataModel: RecipeFieldsDataModel) -> Bool {
        
        guard let name = recipeFieldsDataModel.name,
              let ingredients = recipeFieldsDataModel.ingredients,
              name.isValid(),
              ingredients.isValid() else {
            return false
        }
        return true
    }
    
}

private extension String {
    func isValid() -> Bool {
        
        let result = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if result.count >= 3 {
            return true
        }
        return false
    }
}
