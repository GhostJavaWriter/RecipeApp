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
    
    private lazy var rightBarButton = UIBarButtonItem(title: "Empty Trash", style: .plain, target: self, action: #selector(cleanTrashButtonTapped))
    
    private let delegate = TrashRecipeCollectionViewDelegate()
    private let dataSource = TrashRecipesCollectionViewDataSource()
    private var coreDataStack: CoreDataStack
    
    private lazy var recipesFetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "deletedDate", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "deletedDate != nil")
        let context = coreDataStack.mainContext
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = rightBarButton
        delegate.navigationContoller = navigationController
        do {
            try recipesFetchedResultsController.performFetch()
            if recipesFetchedResultsController.fetchedObjects?.count == 0 {
                rightBarButton.isEnabled = false
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        delegate.fetchedResultsController = recipesFetchedResultsController
        dataSource.fetchedResultsController = recipesFetchedResultsController
        delegate.restoreRecipe = { [weak self] indexPath in
            guard let self = self else { return }
            let object = recipesFetchedResultsController.object(at: indexPath)
            DispatchQueue.main.async {
                object.deletedDate = nil
                self.coreDataStack.saveContextIfHasChanges()
            }
        }
        
        configureView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                collectionView.deleteItems(at: [indexPath])
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                collectionView.insertItems(at: [newIndexPath])
            }
        case .update:
            if let indexPath = indexPath {
                collectionView.reloadItems(at: [indexPath])
            }
        case .move: collectionView.reloadData()
        default: collectionView.reloadData()
        }
        
        if recipesFetchedResultsController.fetchedObjects?.count == 0 {
            rightBarButton.isEnabled = false
        }
    }
    
    @objc func cleanTrashButtonTapped() {
        
        let ac = UIAlertController(title: "Are you sure you want to permanently erase the items in the Trash?", message: "You can’t undo this action.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            let context = coreDataStack.mainContext
            for object in recipesFetchedResultsController.fetchedObjects ?? [] {
                context.delete(object)
            }
            coreDataStack.saveContextIfHasChanges()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
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
