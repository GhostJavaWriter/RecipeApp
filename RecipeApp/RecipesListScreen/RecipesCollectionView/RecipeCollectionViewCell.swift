//
//  RecipeCollectionViewCell.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AmericanTypewriter,
                            size: Fonts.Sizes.recipeName)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var dragImageView = UIImageView.makeImageView(withImage: "recipesImage")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRecipeName() -> String {
        return recipeNameLabel.text ?? "default"
    }
    func configureCell(withText text: String) {
        
        recipeNameLabel.text = text
    }
    
    private func configureView() {
        
        contentView.addSubview(recipeNameLabel)
        contentView.addSubview(dragImageView)
        contentView.layer.cornerRadius = Metrics.RecipeItem.cornerRadius
        contentView.backgroundColor = Colors.RecipeCell.backgroundColor
        
        NSLayoutConstraint.activate([

            recipeNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            
            recipeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dragImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: recipeNameLabel.trailingAnchor, multiplier: 1),
            dragImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dragImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: dragImageView.trailingAnchor, multiplier: 1)
        ])
    }
}

private extension UIImageView {
    
    static func makeImageView(withImage image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: image)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
