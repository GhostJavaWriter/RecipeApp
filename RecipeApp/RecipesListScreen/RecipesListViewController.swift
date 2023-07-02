//
//  RecipesListViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit
import CoreData

final class RecipesListViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var containerView = ButtonsConteinerView(leftButton: addButton, rightButton: trashButton)
    private lazy var addButton = AddButton()
    private lazy var trashButton = makeTrashButton()
    private lazy var collectionView = makeCollectionView()
    
    // MARK: - Properties
    
    var coreDataStack: CoreDataStack
    
    private let currentGroup: RecipesGroup
    private let delegate = RecipesCollectionViewDelegate()
    private let reuseIdentifier = String(describing: RecipeCollectionViewCell.self)
    private let animationDuration = 0.3
    private let defaultGroupName = "default"
    
    private lazy var mainContext = coreDataStack.persistentContainer.viewContext
    private lazy var recipesFetchedResultsController = makeFetchedResultsController()
    private lazy var dataSource = RecipesCollectionViewDataSource(fetchedResultsController: recipesFetchedResultsController)
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack, currentGroup: RecipesGroup) {
        self.coreDataStack = coreDataStack
        self.currentGroup = currentGroup
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
        
        setupUI()
        configureDelegate()
        addButtonTappedEvent()
        trashButtonTappedEvent()
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = Colors.mainBackgroundColor
        view.addSubview(collectionView)
        view.addSubview(containerView)
        setupConstraints()
    }
    
    func setupConstraints() {
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
}

// MARK: - NSFetchedResultsControllerDelegate

extension RecipesListViewController: NSFetchedResultsControllerDelegate {
    
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
    }
}

// MARK: - UICollectionViewDragDelegate

extension RecipesListViewController: UICollectionViewDragDelegate {
    
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

// MARK: - UIDropInteractionDelegate

extension RecipesListViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction,
                         canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal
    {

        animateTrashButton(transform: CGAffineTransform(scaleX: 1.3, y: 1.3))
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidExit session: UIDropSession) {
        animateTrashButton(transform: .identity)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         performDrop session: UIDropSession) {

        animateTrashButton(transform: .identity)
        handleDrop(session: session)
    }
}

// MARK: - Private extension

private extension RecipesListViewController {
    
    func makeFetchedResultsController() -> NSFetchedResultsController<Recipe> {
        let name = currentGroup.name ?? defaultGroupName
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Recipe.name), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "recipesGroup.name == %@ AND deletedDate == nil", name)
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: mainContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }
    
    func handleDrop(session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { [weak self] recipes in
            guard let self = self else { return }
            if let recipe = recipes.first as? String {
                
                coreDataStack.persistentContainer.performBackgroundTask { context in
                    let recipeWithName = self.recipesFetchedResultsController.fetchedObjects?.first {$0.name == recipe}
                    recipeWithName?.deletedDate = Date()
                    DispatchQueue.main.async {
                        self.coreDataStack.saveContextIfHasChanges(context)
                    }
                }
            } else {
                NSLog("recipe error", #function)
            }
        }
    }
    
    func animateTrashButton(transform: CGAffineTransform) {
        UIView.animate(withDuration: animationDuration) {
            self.trashButton.transform = transform
        }
    }
    
    func configureDelegate() {
        delegate.navigationController = navigationController
        delegate.currentGroup = currentGroup
        delegate.coreDataStack = coreDataStack
        delegate.fetchedResultsController = recipesFetchedResultsController
    }
    
    func addButtonTappedEvent() {
        addButton.addButtonTapped = { [weak self] in
            guard let self = self else { return }
            let newRecipeVC = RecipeViewController(mode: .newRecipe, coreDataStack: coreDataStack, currentGroup: currentGroup)
            present(newRecipeVC, animated: true)
        }
    }
    
    func trashButtonTappedEvent() {
        trashButton.trashButtonTapped = { [weak self] in
            guard let self = self else { return }
            let viewModel = TrashRecipesViewModel(coreDataStack: coreDataStack)
            let trashRecipesVC = TrashRecipesViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(trashRecipesVC, animated: true)
        }
    }
    
    func makeTrashButton() -> TrashButton {
        let button = TrashButton()
        button.addInteraction(UIDropInteraction(delegate: self))
        return button
    }
    
    func makeCollectionView() -> RecipesCollectionView {
        let collectionView = RecipesCollectionView()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.dragDelegate = self
        return collectionView
    }
}
