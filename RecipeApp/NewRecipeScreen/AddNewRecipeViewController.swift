//
//  AddNewRecipeViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 3.06.2023.
//

import UIKit

final class AddNewRecipeViewController: UIViewController {
    
    // MARK: - UI
    
    private let nameLabel = UILabel.makeLabel(text: "Name")
    private let ingredientsLabel = UILabel.makeLabel(text: "Ingredients")
    private let methodLabel = UILabel.makeLabel(text: "Method")
    private let linkLabel = UILabel.makeLabel(text: "Link")
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Colors.RecipeCell.backgroundColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var linkTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Colors.RecipeCell.backgroundColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var ingredientsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.RecipeCell.backgroundColor
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    private lazy var methodTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.RecipeCell.backgroundColor
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgroundColor
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(ingredientsLabel)
        view.addSubview(ingredientsTextView)
        view.addSubview(methodLabel)
        view.addSubview(methodTextView)
        view.addSubview(linkLabel)
        view.addSubview(linkTextField)
        
        view.directionalLayoutMargins = Metrics.Margins.screenMargins
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            nameTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            ingredientsLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameTextField.bottomAnchor, multiplier: 1),
            ingredientsLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            ingredientsLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            ingredientsTextView.topAnchor.constraint(equalToSystemSpacingBelow: ingredientsLabel.bottomAnchor, multiplier: 1),
            ingredientsTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            ingredientsTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            methodLabel.topAnchor.constraint(equalToSystemSpacingBelow: ingredientsTextView.bottomAnchor, multiplier: 1),
            methodLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            methodLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            methodTextView.topAnchor.constraint(equalToSystemSpacingBelow: methodLabel.bottomAnchor, multiplier: 1),
            methodTextView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            methodTextView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            linkLabel.topAnchor.constraint(equalToSystemSpacingBelow: methodTextView.bottomAnchor, multiplier: 1),
            linkLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            linkLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            linkTextField.topAnchor.constraint(equalToSystemSpacingBelow: linkLabel.bottomAnchor, multiplier: 1),
            linkTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            linkTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            linkTextField.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            ingredientsTextView.heightAnchor.constraint(equalTo: methodTextView.heightAnchor, multiplier: 1)
        ])
        
    }
}

private extension UILabel {
    
    static func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AmericanTypewriter, size: 20.0)
        label.textColor = .white
        label.text = text
        return label
    }
}
