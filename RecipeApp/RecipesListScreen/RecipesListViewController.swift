//
//  RecipesListViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipesListViewController: UIViewController {
    
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
    
    private lazy var trashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "trashButton")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = dataSource
        table.delegate = delegate
        table.backgroundColor = Colors.mainBackgroundColor
        table.register(RecipeViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        table.separatorStyle = .none
        dataSource.recipesList = recipesList
        dataSource.reuseIdentifier = reuseIdentifier
        return table
    }()
    
    // MARK: - Properties
    private let dataSource = RecipesTableViewDataSource()
    private let delegate = RecipesTableViewDelegate()
    private let reuseIdentifier = String(describing: RecipeViewCell.self)
    
    var recipesList = ["• Summer pie","• Carrot cake","• disdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsdfsh 3","• dish 4", "• dish 4", "• dish 4", "• dish 4", "• dish 4", "• dish 4", "• dish 4"]
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgroundColor
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(addButton)
        containerView.addSubview(trashImageView)
        
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
            middleGuide.trailingAnchor.constraint(equalTo: trashImageView.leadingAnchor),
            trashImageView.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor),
            trailingGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            addButton.widthAnchor.constraint(equalTo: trashImageView.widthAnchor, multiplier: 1),
            leadingGuide.widthAnchor.constraint(equalTo: middleGuide.widthAnchor, multiplier: 1),
            middleGuide.widthAnchor.constraint(equalTo: trailingGuide.widthAnchor, multiplier: 1),
            addButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            trashImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
}
