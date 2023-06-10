//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 3.06.2023.
//

import UIKit

final class RecipeViewController: UIViewController {
    
    // MARK: - UI
    
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
    
    private lazy var rightButton = UIButton.makeButton(withImage: "shareImage")
    private lazy var leftButton = UIButton.makeButton(withImage: "editImage")
    private lazy var containerView = ButtonsConteinerView(leftButton: leftButton, rightButton: rightButton)
    
    private lazy var isEditingMode = false {
        didSet {
            setButtons(isEditing: isEditingMode)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // MARK: - Private methods
    
    private func configureView() {
        
        isEditingMode = false
        
        view.backgroundColor = Colors.mainBackgroundColor
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(scrollView)
        view.addSubview(containerView)
        
        view.directionalLayoutMargins = Metrics.Margins.recipeScreenMargins
        let margins = view.layoutMarginsGuide
        
        let content = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: margins.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
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
            
            ingredientsTextView.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor, multiplier: 0.25),
            methodTextView.heightAnchor.constraint(greaterThanOrEqualTo: margins.heightAnchor, multiplier: 0.25)
        ])
    }
    
    @objc private func shareButtonTapped() {
        // Prepare the text to share
        let recipeName = nameTextField.text ?? ""
        let recipeIngredients = ingredientsTextView.text ?? ""
        let recipeMethod = methodTextView.text ?? ""
        let recipeLink = linkTextField.text ?? ""
        
        let shareText = "Recipe Name: \(recipeName)\nIngredients: \(recipeIngredients)\nMethod: \(recipeMethod)\nLink: \(recipeLink)"
        
        // Create an instance of UIActivityViewController and pass the sharing text to it
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        // Toggle editing
        isEditingMode.toggle()
        nameTextField.becomeFirstResponder()
    }
    
    @objc func cancelChanges() {
        print("cancel")
        isEditingMode.toggle()
        view.endEditing(true)
    }
    
    @objc func saveRecipe() {
        print("save recipe")
        isEditingMode.toggle()
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func setButtons(isEditing: Bool) {
        
        let leftButtonImageName = isEditing ? "saveImage" : "editImage"
        let rightButtonImageName = isEditing ? "cancelImage" : "shareImage"
        leftButton.setImage(UIImage(named: leftButtonImageName), for: .normal)
        rightButton.setImage(UIImage(named: rightButtonImageName), for: .normal)
        
        if isEditing {
            leftButton.removeTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            leftButton.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
            rightButton.removeTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
        } else {
            leftButton.removeTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
            leftButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            rightButton.removeTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        }
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

private extension UIButton {
    static func makeButton(withImage image: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: image), for: .normal)
        return button
    }
}
