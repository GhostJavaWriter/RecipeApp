//
//  RecipeViewCell.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 1.06.2023.
//

import UIKit

final class RecipeViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.recipeNameFont,
                            size: Fonts.Sizes.recipeName)
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.RecipeCell.backgroundColor
        view.layer.cornerRadius = Metrics.RecipeItem.cornerRadius
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configureCell(withText text: String) {
        
        recipeNameLabel.text = text
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(recipeNameLabel)
        
        contentView.directionalLayoutMargins = Metrics.Margins.spaceBetweenCells
        containerView.directionalLayoutMargins = Metrics.Margins.cellContentInsets
        
        let margins = contentView.layoutMarginsGuide
        let insets = containerView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            recipeNameLabel.topAnchor.constraint(equalTo: insets.topAnchor),
            recipeNameLabel.bottomAnchor.constraint(equalTo: insets.bottomAnchor),
            recipeNameLabel.leadingAnchor.constraint(equalTo: insets.leadingAnchor),
            recipeNameLabel.trailingAnchor.constraint(equalTo: insets.trailingAnchor)
        ])
        
    }
}
