//
//  TrashRecipesViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 11.06.2023.
//

import UIKit
import CoreData

final class TrashRecipesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private lazy var collectionView: RecipesCollectionView = {
        let collectionView = RecipesCollectionView()
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        return collectionView
    }()
    
    private let delegate = TrashRecipeCollectionViewDelegate()
    private let dataSource = TrashRecipesCollectionViewDataSource()
    private var dataManager: RecipesDataManager
    
    
    private lazy var recipesFetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deletedDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "deletedDate != nil")
        let context = dataManager.getContext()
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    init(dataManager: RecipesDataManager) {
        self.dataManager = dataManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try recipesFetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        delegate.fetchedResultsController = recipesFetchedResultsController
        dataSource.fetchedResultsController = recipesFetchedResultsController
        delegate.restoreRecipe = { [weak self] indexPath in
            if let object = self?.recipesFetchedResultsController.object(at: indexPath) {
                DispatchQueue.main.async {
                    object.deletedDate = nil
                    self?.dataManager.saveContext()
                }
            } else {
                print("dfdf")
            }
        }
        
        configureView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath {
            collectionView.deleteItems(at: [indexPath])
        }
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
