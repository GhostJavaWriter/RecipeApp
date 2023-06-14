//
//  RecipesListViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipesListViewController: UIViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate, RecipesDataManaging {
    
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
    private let currentCategorie: Categories
    private lazy var recipesList = dataManager.getRecipesWith(currentCategorie)
    private lazy var dataSource = RecipesCollectionViewDataSource(dataManager: dataManager)
    private let delegate = RecipesCollectionViewDelegate()
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    
    init(dataManager: RecipesDataManager, categorie: Categories) {
        self.dataManager = dataManager
        self.currentCategorie = categorie
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
        trashButton.addInteraction(UIDropInteraction(delegate: self))
        
        addButton.addButtonTapped = { [weak self] in
            let newRecipeVC = RecipeViewController(mode: .newRecipe)
            self?.present(newRecipeVC, animated: true)
        }
        
        trashButton.trashButtonTapped = { [weak self] in
            let trashRecipesVC = TrashRecipesViewController()
            trashRecipesVC.trashRecipes = self?.trashRecipes
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
        if let recipeName = (collectionView.cellForItem(at: indexPath) as? RecipeCollectionViewCell)?.getRecipeName() as? NSString {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: recipeName as NSItemProviderWriting))
            dragItem.localObject = recipeName
            
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
                if let recipeName = item.dragItem.localObject as? RecipeModel {
                    
                    collectionView.performBatchUpdates {
                        recipesList.remove(at: sourceIndexPath.row)
                        recipesList.insert(recipeName, at: destinationIndexPath.row)
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

    // MARK: - UIDropInteractionDelegate
    
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
            if let recipe = recipes.first as? String {
                if let index = self?.recipesList.firstIndex(of: recipe) {
                    self?.recipesList.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self?.collectionView.deleteItems(at: [indexPath])
                    self?.trashRecipes.append(recipe)
                }
            }
        }
    }
    
}
