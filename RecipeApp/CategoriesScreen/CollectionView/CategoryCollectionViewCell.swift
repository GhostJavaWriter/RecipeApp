//
//  CategoryCollectionViewCell.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.CategorieItem.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.categorieItemFont,
                            size: Fonts.Sizes.categorieName)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(categoryNameLabel)
        
        contentView.backgroundColor = Colors.CategorieItem.backgroundColor
        
        NSLayoutConstraint.activate([
            categoryNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        setFontSize()
        contentView.layer.cornerRadius = Metrics.CategorieItem.cornerRadius
        contentView.layer.borderWidth = Metrics.CategorieItem.borderWidth
        contentView.layer.borderColor = Colors.CategorieItem.borderColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFontSize() {
        
        let fontName = Fonts.categorieItemFont
        
        switch UIScreen.main.bounds.height {
        
        case 667.0: // iPhone 6,6s,7,8,SE (2nd generation)
            categoryNameLabel.font = UIFont(name: fontName, size: 23)
        default:
            categoryNameLabel.font = UIFont(name: fontName, size: Fonts.Sizes.categorieName)
        }

    }
}
