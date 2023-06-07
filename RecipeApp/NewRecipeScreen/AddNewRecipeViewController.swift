//
//  AddNewRecipeViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 3.06.2023.
//

import UIKit

final class AddNewRecipeViewController: UIViewController {
    
    // MARK: - UI
    
    // TODO: adapt for keyboard appearance
    // TODO: add dots as placeholder?
    
    private let nameLabel = UILabel.makeLabel(text: "Name")
    private let ingredientsLabel = UILabel.makeLabel(text: "Ingredients")
    private let methodLabel = UILabel.makeLabel(text: "Method")
    private let linkLabel = UILabel.makeLabel(text: "Link")
    private lazy var nameTextField = CustomTextField.makeTextField()
    private lazy var linkTextField = CustomTextField.makeTextField()
    private lazy var ingredientsTextView = UITextView.makeTextView()
    private lazy var methodTextView = UITextView.makeTextView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(ingredientsTextView)
        scrollView.addSubview(methodLabel)
        scrollView.addSubview(methodTextView)
        scrollView.addSubview(linkLabel)
        scrollView.addSubview(linkTextField)
        return scrollView
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plane"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
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
        view.addSubview(shareButton)
        view.addSubview(editButton)
        view.addSubview(scrollView)
        
        view.directionalLayoutMargins = Metrics.Margins.screenMargins
        let margins = view.layoutMarginsGuide

        let content = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),
            
            editButton.topAnchor.constraint(equalTo: margins.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor),
            
            shareButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            shareButton.topAnchor.constraint(equalTo: margins.topAnchor),
            
            nameTextField.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            nameTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: nameLabel.font.pointSize * 1.5),
            
            scrollView.widthAnchor.constraint(equalTo: content.widthAnchor, multiplier: 1),
            
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: nameTextField.bottomAnchor, multiplier: 1),
            scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
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
            
            ingredientsTextView.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor, multiplier: 0.3),
            methodTextView.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor, multiplier: 0.3)
        ])
    }
    
    @objc private func shareButtonTapped() {
        // TODO: Share
        print("share")
    }
}

// MARK: - Private extensions

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

private extension UITextView {
    
    static func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.RecipeCell.backgroundColor
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: Fonts.AmericanTypewriter, size: 18)
        textView.textColor = UIColor(hex: "#434443")
        textView.isScrollEnabled = false
        return textView
    }
}
