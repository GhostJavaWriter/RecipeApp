//
//  RecipesListViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipesListViewController: UIViewController, UITableViewDragDelegate, UITableViewDropDelegate {
    
    // MARK: - UI
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addButton: AddButton = {
        let button = AddButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "addButton"), for: .normal)
        return button
    }()
    
    private lazy var trashButton: TrashButton = {
        let button = TrashButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "trashButton"), for: .normal)
        return button
    }()
    
    private lazy var dropZone: UIView = {
        let view = UIView()
        //        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = dataSource
        table.delegate = delegate
        table.backgroundColor = Colors.mainBackgroundColor
        table.register(RecipeViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        table.separatorStyle = .none
        table.dragDelegate = self
        table.dropDelegate = self
        dataSource.recipesList = recipesList
        dataSource.reuseIdentifier = reuseIdentifier
        return table
    }()
    
    // MARK: - Properties
    private let dataSource = RecipesTableViewDataSource()
    private let delegate = RecipesTableViewDelegate()
    private let reuseIdentifier = String(describing: RecipeViewCell.self)
    
    var recipesList = ["• Summer pie","• Carrot cake","• disdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsh 3","• dish 4", "• dish 4", "• dish 4", "• dish 4", "• dish 4", "• dish 4", "• dish 4"] {
        didSet {
            dataSource.recipesList = recipesList
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgroundColor
        view.addSubview(tableView)
        view.addSubview(dropZone)
        view.addSubview(containerView)
        
        containerView.addSubview(addButton)
        containerView.addSubview(trashButton)
        
        let margins = view.layoutMarginsGuide
        
        let leadingGuide = UILayoutGuide()
        let middleGuide = UILayoutGuide()
        let trailingGuide = UILayoutGuide()
        
        containerView.addLayoutGuide(leadingGuide)
        containerView.addLayoutGuide(middleGuide)
        containerView.addLayoutGuide(trailingGuide)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1),
            
            containerView.heightAnchor.constraint(equalTo: addButton.heightAnchor, multiplier: 2),
            
            containerView.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor),
            leadingGuide.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: middleGuide.leadingAnchor),
            middleGuide.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor),
            trashButton.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor),
            trailingGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            addButton.widthAnchor.constraint(equalTo: trashButton.widthAnchor, multiplier: 1),
            leadingGuide.widthAnchor.constraint(equalTo: middleGuide.widthAnchor, multiplier: 1),
            middleGuide.widthAnchor.constraint(equalTo: trailingGuide.widthAnchor, multiplier: 1),
            addButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            trashButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            dropZone.leadingAnchor.constraint(equalTo: trashButton.leadingAnchor),
            dropZone.trailingAnchor.constraint(equalTo: trashButton.trailingAnchor),
            dropZone.topAnchor.constraint(equalTo: trashButton.topAnchor),
            dropZone.bottomAnchor.constraint(equalTo: trashButton.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDragDelegate
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let recipeName = (tableView.cellForRow(at: indexPath) as? RecipeViewCell)?.getRecipeName() {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: recipeName as NSItemProviderWriting))
            dragItem.localObject = recipeName
            
            return [dragItem]
        } else {
            return []
        }
    }
    
    // MARK: - UITableViewDropDelegate
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let recipeName = item.dragItem.localObject as? String {
                    
                    tableView.performBatchUpdates {
                        recipesList.remove(at: sourceIndexPath.row)
                        recipesList.insert(recipeName, at: destinationIndexPath.row)
                        tableView.deleteRows(at: [sourceIndexPath], with: .fade)
                        tableView.insertRows(at: [destinationIndexPath], with: .automatic)
                    }
                    
                    coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }

    
}
