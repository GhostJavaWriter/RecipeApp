//
//  RecipesListViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit
import CoreData

final class RecipesListViewController: UIViewController, UICollectionViewDragDelegate, RecipesDataManaging, NSFetchedResultsControllerDelegate {
    
    // MARK: - UI
    
    private lazy var containerView = ButtonsConteinerView(leftButton: addButton, rightButton: trashButton)
    
    private lazy var addButton = AddButton()
    private lazy var trashButton: TrashButton = {
        let button = TrashButton()
        button.addInteraction(UIDropInteraction(delegate: self))
        return button
    }()
    
    private lazy var collectionView: RecipesCollectionView = {
        let collectionView = RecipesCollectionView()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.dragDelegate = self
        return collectionView
    }()
    
    // MARK: - Properties
    private lazy var recipesFetchedResultsController: NSFetchedResultsController = {
        let name = currentGroup.name!
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Recipe.name), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "recipesGroup.name == %@ AND deletedDate == nil", name)
        let context = dataManager.getContext()
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: context,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()
    
    var dataManager: RecipesDataManager
    private let currentGroup: RecipesGroup
    private lazy var dataSource = RecipesCollectionViewDataSource(fetchedResultsController: recipesFetchedResultsController)
    private let delegate = RecipesCollectionViewDelegate()
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    init(dataManager: RecipesDataManager, categorie: RecipesGroup) {
        self.dataManager = dataManager
        self.currentGroup = categorie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try recipesFetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        configureView()
        
        delegate.navigationController = navigationController
        
        addButton.addButtonTapped = { [weak self] in
            guard let self = self else { return }
            let newRecipeVC = RecipeViewController(mode: .newRecipe, dataManager: self.dataManager, currentGroup: currentGroup)
            self.present(newRecipeVC, animated: true)
        }
        
        trashButton.trashButtonTapped = { [weak self] in
            guard let self = self else { return }
            let trashRecipesVC = TrashRecipesViewController(dataManager: self.dataManager)
            self.navigationController?.pushViewController(trashRecipesVC, animated: true)
        }
        
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgroundColor
        view.addSubview(collectionView)
        view.addSubview(containerView)
        
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            
            containerView.heightAnchor.constraint(equalTo: addButton.heightAnchor, multiplier: 2),
            
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath {
            collectionView.deleteItems(at: [indexPath])
        }
        
        if let newIndexPath = newIndexPath {
            collectionView.insertItems(at: [newIndexPath])
        }
    }
    
    // MARK: - UITableViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView,
                        itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath,
                        point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let recipe = (collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell)?.getRecipeName() as? NSString {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: recipe as NSItemProviderWriting))
            dragItem.localObject = recipe

            return [dragItem]
        } else {
            return []
        }
    }
}

extension RecipesListViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction,
                         canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal
    {

        UIView.animate(withDuration: 0.3) {
            self.trashButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidExit session: UIDropSession) {
        UIView.animate(withDuration: 0.3) {
            self.trashButton.transform = .identity
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         performDrop session: UIDropSession) {

        UIView.animate(withDuration: 0.3) {
            self.trashButton.transform = .identity
        }

        session.loadObjects(ofClass: NSString.self) { [weak self] recipes in
            guard let self = self else { return }
            if let recipe = recipes.first as? String {
                
                self.dataManager.getPersistentContainer().performBackgroundTask { context in
                    let recipeWithName = self.recipesFetchedResultsController.fetchedObjects?.first {$0.name == recipe}
                    recipeWithName?.deletedDate = Date()
                    DispatchQueue.main.async {
                        self.dataManager.saveContext()
                    }
                }
            } else {
                NSLog("recipe error", #function)
            }
        }
    }
}
