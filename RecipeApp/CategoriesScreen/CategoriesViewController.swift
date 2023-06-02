//
//  CategoriesViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {

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
        collectionView.delegate = delegate
        return collectionView
    }()
    
    // MARK: - Properties
        
    private let dataSource = CategoriesCollectionViewDataSource()
    private let delegate = CategoriesCollectionViewDelegate()
    
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
            
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: margins.topAnchor, multiplier: 1),
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

