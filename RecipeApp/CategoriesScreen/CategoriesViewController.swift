//
//  CategoriesViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

final class CategoriesViewController: UIViewController, RecipesDataManaging {

    // MARK: - UI
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What will we cook?"
        label.textColor = Colors.welcomeLabelColor
        label.font = UIFont(name: Fonts.welcomeLabelFont,
                            size: Fonts.Sizes.welcomeLabel)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: CategoriesCollectionView = {
        let collectionView = CategoriesCollectionView()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Properties
    
    var dataManager: RecipesDataManager
    private lazy var dataSource = CategoriesCollectionViewDataSource(dataManager: dataManager)
    
    // MARK: - Init
    
    init(dataManager: RecipesDataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgroundColor
        
        view.addSubview(containerView)
        view.addSubview(collectionView)
        containerView.addSubview(welcomeLabel)
        
        let margins = view.layoutMarginsGuide
        view.directionalLayoutMargins = Metrics.Margins.screenMargins
        
        NSLayoutConstraint.activate([
            
            // configure caption label
            
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
            // configure collection view
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let originalTransform = cell.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.95, y: 0.95)
        
        cell.transform = scaledTransform
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            cell.transform = originalTransform
        }, completion: nil)
        
        let recipesGroups = dataManager.getRecipesGroups()
        let currentGroup = recipesGroups[indexPath.row]
        let recipesVC = RecipesListViewController(dataManager: dataManager, categorie: currentGroup)
        navigationController?.pushViewController(recipesVC, animated: true)
    }
    
    
}

