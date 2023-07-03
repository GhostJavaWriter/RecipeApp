//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 3.06.2023.
//

import UIKit

final class RecipeViewController: UIViewController {
    
    // MARK: - UI
    
    private let nameLabel = UILabel.makeLabel(text: "Name")
    private let nameTextField = CustomTextField.makeTextField()
    private let scrollView = CustomScrollView()
    private let rightButton = UIButton.makeButton(withImage: "shareImage")
    private let leftButton = UIButton.makeButton(withImage: "editImage")
    private lazy var containerView = ButtonsConteinerView(leftButton: leftButton, rightButton: rightButton)
    
    // MARK: - Properties
    private let viewModel: RecipeViewModel
    private lazy var isEditingMode = false {
        didSet {
            setButtons(isEditing: isEditingMode)
        }
    }
    
    // MARK: - Init
    
    init(viewModel: RecipeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        configureView()
        configureRecipeData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    // share/cancel actions
    @objc private func rightButtonTapped() {
        switch viewModel.type {
        case .view:
            if !isEditingMode {
                let shareText = viewModel.setupRecipeDataForShare(recipeFieldsDataModel: getRecipeFields())
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
                self.present(vc, animated: true, completion: nil)
            } else {
                view.endEditing(true)
                navigationController?.popViewController(animated: true)
            }
        case .newRecipe:
            dismiss(animated: true)
        }
    }
    
    // edit/save actions
    @objc private func leftButtonTapped() {
        switch viewModel.type {
        // ViewController opens in viewing/editing type
        case .view:
            // Change buttons images and actions from edit and share to save and cancel
            if !isEditingMode {
                // turn on edit buttons action
                isEditingMode.toggle()
                nameTextField.becomeFirstResponder()
            } else {
                // turn off edit mode and saves recipe changes when tapped once again.
                viewModel.saveRecipeWith(recipeFieldsDataModel: getRecipeFields())
                isEditingMode.toggle()
                view.endEditing(true)
                navigationController?.popViewController(animated: true)
            }
        case .newRecipe:
            viewModel.saveRecipeWith(recipeFieldsDataModel: getRecipeFields())
            dismiss(animated: true)
        }
    }
    
    @objc private func textsDidChange() {
        
        let isValid = viewModel.recipeFieldsIsValid(recipeFieldsDataModel: getRecipeFields())
        if isValid {
            leftButton.isEnabled = true
            return
        }
        leftButton.isEnabled = false
    }
    
    // MARK: - Private methods
    
    private func getRecipeFields() -> RecipeFieldsDataModel {
        
        let nameText = nameTextField.text
        let ingredientsText = scrollView.ingredientsTextView.text
        let methodText = scrollView.methodTextView.text
        let link = scrollView.linkTextView.text
        return RecipeFieldsDataModel(name: nameText,
                                     ingredients: ingredientsText,
                                     method: methodText,
                                     link: link)
    }
    
    private func configureRecipeData() {
        guard let recipe = viewModel.currentRecipe else { return }
        nameTextField.text = recipe.name
        scrollView.ingredientsTextView.text = recipe.ingredients
        scrollView.methodTextView.text = recipe.cookMethod
        scrollView.linkTextView.text = recipe.link
    }
    
    private func setupTextFields() {
        nameTextField.addTarget(self, action: #selector(textsDidChange), for: .editingChanged)
        scrollView.linkTextView.delegate = self
        scrollView.ingredientsTextView.delegate = self
        scrollView.methodTextView.delegate = self
    }
    
    private func setButtons(isEditing: Bool) {
        nameTextField.isUserInteractionEnabled = isEditing
        scrollView.setEditable(isEditing: isEditing)
        let leftButtonImageName = isEditing ? "saveImage" : "editImage"
        let rightButtonImageName = isEditing ? "cancelImage" : "shareImage"
        leftButton.setImage(UIImage(named: leftButtonImageName), for: .normal)
        rightButton.setImage(UIImage(named: rightButtonImageName), for: .normal)
    }
    
    // MARK: - SetupUI
    
    private func configureView() {
        switch viewModel.type {
        case .view:
            isEditingMode = false
        case .newRecipe:
            leftButton.isEnabled = false
            isEditingMode = true
        }
        
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
            nameTextField.heightAnchor.constraint(equalToConstant: nameLabel.font.pointSize * 2.27),
            scrollView.widthAnchor.constraint(equalTo: content.widthAnchor, multiplier: 1),
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: nameTextField.bottomAnchor, multiplier: 1),
            scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    // MARK: - Keyboard adjust handle
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
}

// MARK: - Private extensions

extension RecipeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textsDidChange()
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

private extension UIButton {
    static func makeButton(withImage image: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setImage(UIImage(named: image), for: .normal)
        return button
    }
}
