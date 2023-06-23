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
    
    private lazy var welcomeLabelP1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What will"
        label.textColor = Colors.welcomeLabelColor
        label.font = UIFont(name: Fonts.welcomeLabelFont,
                            size: Fonts.Sizes.welcomeLabel)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var welcomeLabelP2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "we cook?"
        label.textColor = Colors.welcomeLabelColor
        label.font = UIFont(name: Fonts.welcomeLabelFont,
                            size: Fonts.Sizes.welcomeLabel)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var collectionView: CategoriesCollectionView = {
        let collectionView = CategoriesCollectionView()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var margins = Metrics.Margins.screenMargins
    
    // MARK: - Properties
    
    private var coreDataStack: CoreDataStack
    private lazy var dataSource = CategoriesCollectionViewDataSource(coreDataStack: coreDataStack)
    
    // MARK: - Init
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFontSize()
        configureView()
    }

    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgroundColor
        
        view.addSubview(containerView)
        view.addSubview(collectionView)
        containerView.addSubview(welcomeLabelP1)
        containerView.addSubview(welcomeLabelP2)
        
        let margins = view.layoutMarginsGuide
        view.directionalLayoutMargins = self.margins
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25),
            
            welcomeLabelP1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabelP1.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: welcomeLabelP1.trailingAnchor),
            welcomeLabelP1.bottomAnchor.constraint(equalTo: welcomeLabelP2.topAnchor),
            
            welcomeLabelP2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabelP2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            welcomeLabelP2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        
    }
    
    private func setFontSize() {
        
        let fontName = Fonts.welcomeLabelFont
        
        switch UIScreen.main.bounds.height {
        
        case 667.0: // iPhone 6,6s,7,8,SE (2nd generation)
            welcomeLabelP1.font = UIFont(name: fontName, size: 45)
            welcomeLabelP2.font = UIFont(name: fontName, size: 45)
            margins = NSDirectionalEdgeInsets(top: 0,
                                              leading: 60,
                                              bottom: 20,
                                              trailing: 60)
        default:
            welcomeLabelP1.font = UIFont(name: fontName, size: Fonts.Sizes.welcomeLabel)
            welcomeLabelP2.font = UIFont(name: fontName, size: Fonts.Sizes.welcomeLabel)
            margins = Metrics.Margins.screenMargins
        }

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
        
        let currentGroup = coreDataStack.getRecipesGroupAt(indexPath)
        let recipesVC = RecipesListViewController(coreDataStack: coreDataStack, currentGroup: currentGroup)
        navigationController?.pushViewController(recipesVC, animated: true)
    }
    
    
}

