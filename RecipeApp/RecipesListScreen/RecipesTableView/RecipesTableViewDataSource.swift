//
//  RecipesTableViewDataSource.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipesTableViewDataSource: NSObject, UITableViewDataSource {
    
    var reuseIdentifier: String?
    
    var recipesList: [String]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let reuseID = reuseIdentifier,
              let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? RecipeViewCell else {
            return UITableViewCell()
        }
        
        if let recipesList = recipesList {
            cell.configureCell(withText: recipesList[indexPath.row])
        } 
        return cell
    }
    
}
