//
//  CategoriesViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var containerView = makeView()
    private lazy var welcomeLabelP1 = makeWelcomeLabel(withText: "What will", alignment: .left)
    private lazy var welcomeLabelP2 = makeWelcomeLabel(withText: "we cook?", alignment: .right)
    private lazy var collectionView: UICollectionView = {
        let reuseIdentifier = viewModel.reuseIdentifier
        let collectionView = CategoriesCollectionView(reuseIdentifier: reuseIdentifier)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        return collectionView
    }()
    
    private var margins = Metrics.Margins.screenMargins
    
    // MARK: - Properties
    private let viewModel: CategoriesViewModel
    private let dataSource: CategoriesCollectionViewDataSource
    private lazy var delegate = CategoriesCollectionViewDelegate(viewModel: viewModel, navigationController: navigationController)
    
    // MARK: - Init
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        self.dataSource = CategoriesCollectionViewDataSource(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.mainBackgroundColor
        setupContainerView()
        setupCollectionView()
        setupWelcomeLabels()
        updateFontSizeAndMargins()
    }
    
    // MARK: - Setup UI
    
    private func setupContainerView() {
        view.addSubview(containerView)
        let margins = view.layoutMarginsGuide
        view.directionalLayoutMargins = self.margins
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25),
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    private func setupWelcomeLabels() {
        containerView.addSubview(welcomeLabelP1)
        containerView.addSubview(welcomeLabelP2)
        NSLayoutConstraint.activate([
            welcomeLabelP1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabelP1.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: welcomeLabelP1.trailingAnchor),
            welcomeLabelP1.bottomAnchor.constraint(equalTo: welcomeLabelP2.topAnchor),
            welcomeLabelP2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabelP2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            welcomeLabelP2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    private func updateFontSizeAndMargins() {
        let fontName = Fonts.welcomeLabelFont
        switch UIScreen.main.bounds.height {
        case 667.0: // iPhone 6,6s,7,8,SE (2nd generation)
            updateFonts(withName: fontName, size: 45)
            margins = NSDirectionalEdgeInsets(top: 0, leading: 60, bottom: 20, trailing: 60)
        default:
            updateFonts(withName: fontName, size: Fonts.Sizes.welcomeLabel)
            margins = Metrics.Margins.screenMargins
        }
    }
    
    private func updateFonts(withName fontName: String, size: CGFloat) {
        welcomeLabelP1.font = UIFont(name: fontName, size: size)
        welcomeLabelP2.font = UIFont(name: fontName, size: size)
    }
    
    // MARK: - Factory methods

    private func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func makeWelcomeLabel(withText text: String, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = Colors.welcomeLabelColor
        label.font = UIFont(name: Fonts.welcomeLabelFont, size: Fonts.Sizes.welcomeLabel)
        label.textAlignment = alignment
        return label
    }
}


