//
//  RecipesListViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipesListViewController: UIViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate, RecipesDataManaging {
    
    // MARK: - UI
    
    private lazy var containerView = ButtonsConteinerView(leftButton: addButton, rightButton: trashButton)
    
    private lazy var addButton = AddButton()
    private lazy var trashButton = TrashButton()
    
    private lazy var collectionView: RecipesCollectionView = {
        let collectionView = RecipesCollectionView()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        return collectionView
    }()
    
    // MARK: - Properties
    
    var dataManager: RecipesDataManager
    private let currentGroup: RecipesGroup
    private lazy var recipesList = currentGroup.recipes?.array as? [Recipe]
    private lazy var dataSource = RecipesCollectionViewDataSource(dataManager: dataManager, categorie: currentGroup)
    private let delegate = RecipesCollectionViewDelegate()
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    private lazy var newRecipeVC = RecipeViewController(mode: .newRecipe, dataManager: self.dataManager, currentGroup: self.currentGroup)
    
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
        
        configureView()
        
        delegate.navigationController = navigationController
        let dropDelegate = DropInteractionDelegate(for: trashButton)
        trashButton.addInteraction(UIDropInteraction(delegate: dropDelegate))
        
        newRecipeVC.updateData = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        addButton.addButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.present(newRecipeVC, animated: true)
        }
        
        trashButton.trashButtonTapped = { [weak self] in
            let trashRecipesVC = TrashRecipesViewController()
//            trashRecipesVC.trashRecipes = self?.dataManager.getDeletedRecipes()
            self?.navigationController?.pushViewController(trashRecipesVC, animated: true)
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
        if let recipe = (collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell)?.getRecipeName() {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: recipe as NSItemProviderWriting))
            dragItem.localObject = recipe

            return [dragItem]
        } else {
            return []
        }
    }
    
    // MARK: - UITableViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)

        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let recipe = item.dragItem.localObject as? Recipe {

                    collectionView.performBatchUpdates {
                        recipesList?.remove(at: sourceIndexPath.row)
                        recipesList?.insert(recipe, at: destinationIndexPath.row)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }

                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
}
