//
//  TrashRecipesViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 11.06.2023.
//

import UIKit

final class TrashRecipesViewController: UIViewController {
    
    private lazy var collectionView: RecipesCollectionView = {
        let collectionView = RecipesCollectionView()
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        return collectionView
    }()
    
    private let delegate = TrashRecipeCollectionViewDelegate()
    private let dataSource = TrashRecipesCollectionViewDataSource()
    
    var trashRecipes: [String]?
    var recipesList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recipes = trashRecipes {
            dataSource.recipesList = recipes
            delegate.deletedRecipesList = recipes
        }
        
        delegate.restoreRecipe = { [weak self] recipe in
            if let index = self?.trashRecipes?.firstIndex(of: recipe) {
                let indexPath = IndexPath(item: index, section: 0)
                self?.dataSource.recipesList.remove(at: index)

                self?.collectionView.deleteItems(at: [indexPath])
            }
        }
        
        configureView()
    }
    
    private func configureView() {
        
        view.addSubview(collectionView)
        view.backgroundColor = Colors.mainBackgroundColor
        view.directionalLayoutMargins = Metrics.Margins.recipeScreenMargins
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: margins.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
    }
}
