//
//  CustomScrollView.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

final class CustomScrollView: UIScrollView {
    
    // MARK: - UI
    
    private let methodLabel = UILabel.makeLabel(text: "Method")
    private let ingredientsLabel = UILabel.makeLabel(text: "Ingredients")
    private let linkLabel = UILabel.makeLabel(text: "Link")
    private(set) lazy var linkTextField = CustomTextField.makeTextField()
    private(set) lazy var ingredientsTextView = UITextView.makeTextView()
    private(set) lazy var methodTextView = UITextView.makeTextView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEditable(isEditing: Bool) {
        ingredientsTextView.isEditable = isEditing
        methodTextView.isEditable = isEditing
        linkTextField.isUserInteractionEnabled = isEditing
    }
    
    private func configureView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        let content = contentLayoutGuide
        
        addSubview(methodLabel)
        addSubview(ingredientsLabel)
        addSubview(linkLabel)
        addSubview(linkTextField)
        addSubview(ingredientsTextView)
        addSubview(methodTextView)
        
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: content.topAnchor),
            ingredientsLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            ingredientsLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            
            ingredientsTextView.topAnchor.constraint(equalToSystemSpacingBelow: ingredientsLabel.bottomAnchor, multiplier: 1),
            ingredientsTextView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            ingredientsTextView.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            
            methodLabel.topAnchor.constraint(equalToSystemSpacingBelow: ingredientsTextView.bottomAnchor, multiplier: 1),
            methodLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            methodLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            
            methodTextView.topAnchor.constraint(equalToSystemSpacingBelow: methodLabel.bottomAnchor, multiplier: 1),
            methodTextView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            methodTextView.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            
            linkLabel.topAnchor.constraint(equalToSystemSpacingBelow: methodTextView.bottomAnchor, multiplier: 1),
            linkLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            linkLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            
            linkTextField.topAnchor.constraint(equalToSystemSpacingBelow: linkLabel.bottomAnchor, multiplier: 1),
            linkTextField.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            linkTextField.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            linkTextField.bottomAnchor.constraint(equalTo: content.bottomAnchor),
            linkTextField.heightAnchor.constraint(equalToConstant: linkLabel.font.pointSize * 1.5),
            
            ingredientsTextView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.3),
            methodTextView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.3)
        ])
    }
}

private extension UITextView {
    
    static func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.RecipeCell.backgroundColor
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: Fonts.AmericanTypewriter, size: 18)
        textView.textColor = Colors.textsViewsColor
        textView.isScrollEnabled = false
        return textView
    }
}

private extension UILabel {
    
    static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AmericanTypewriter, size: 18.0)
        label.textColor = .white
        label.text = text
        return label
    }
}

