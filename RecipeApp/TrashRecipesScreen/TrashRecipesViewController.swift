//
//  TrashRecipesViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 11.06.2023.
//

import UIKit
import CoreData

final class TrashRecipesViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var collectionView: RecipesCollectionView = {
        let collectionView = RecipesCollectionView()
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        return collectionView
    }()
    
    private lazy var rightBarButton = UIBarButtonItem(title: "Empty Trash", style: .plain, target: self, action: #selector(cleanTrashButtonTapped))
    
    // MARK: - Properties
    
    private lazy var delegate = TrashRecipeCollectionViewDelegate(viewModel: viewModel)
    private lazy var dataSource = TrashRecipesCollectionViewDataSource(viewModel: viewModel)
    private var viewModel: TrashRecipesViewModel
    
    // MARK: - Init
    
    init(viewModel: TrashRecipesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = rightBarButton
        viewModel.recipesFetchedResultsController.delegate = self
        do {
            let recipes = try viewModel.fetchData()
            if recipes.count == 0 {
                rightBarButton.isEnabled = false
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        configureView()
    }
    
    // MARK: - Actions
    
    @objc func cleanTrashButtonTapped() {
        
        let ac = UIAlertController(title: "Are you sure you want to permanently erase the items in the Trash?", message: "You can’t undo this action.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            
            guard let self = self else { return }
            
            self.viewModel.emptyTrash()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    // MARK: - SetupUI
    
    private func configureView() {
        
        view.addSubview(collectionView)
        view.backgroundColor = Colors.mainBackgroundColor
        view.directionalLayoutMargins = Metrics.Margins.recipeScreenMargins
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: margins.topAnchor, multiplier: 1),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        ])
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrashRecipesViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let _ = controller.fetchedObjects?.isEmpty {
            collectionView.reloadData()
            rightBarButton.isEnabled = false
            return
        }
        
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
    }
}
