//
//  RecipesListTableViewDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipesListTableViewDelegate: NSObject, UITableViewDelegate
{
    var navigationController: UINavigationController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let originalTransform = cell.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.95, y: 0.95)
        
        cell.transform = scaledTransform
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = originalTransform
        }, completion: nil)
        
        let recipeVC = RecipeViewController(mode: .view)
        navigationController?.pushViewController(recipeVC, animated: true)
    }

}
