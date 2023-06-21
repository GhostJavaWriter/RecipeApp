//
//  RecipeViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 3.06.2023.
//

import UIKit

enum RecipeViewControllerMode {
    case view
    case newRecipe
}

final class RecipeViewController: UIViewController, RecipesDataManaging {
    
    // MARK: - UI
    
    private let nameLabel = UILabel.makeLabel(text: "Name")
    private let nameTextField = CustomTextField.makeTextField()
    private let scrollView = CustomScrollView()
    
    private let rightButton = UIButton.makeButton(withImage: "shareImage")
    private let leftButton = UIButton.makeButton(withImage: "editImage")
    private lazy var containerView = ButtonsConteinerView(leftButton: leftButton, rightButton: rightButton)
    
    // MARK: - Properties
    
    var dataManager: RecipesDataManager
    private var currentGroup: RecipesGroup
    private var currentRecipe: Recipe?
    private var mode: RecipeViewControllerMode
    private lazy var isEditingMode = false {
        didSet {
            setButtons(isEditing: isEditingMode)
        }
    }
    
    // MARK: - Init
    
    init(mode: RecipeViewControllerMode, dataManager: RecipesDataManager, currentGroup: RecipesGroup) {
        self.mode = mode
        self.dataManager = dataManager
        self.currentGroup = currentGroup
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Public methods
    
    func configureRecipe(withModel model: Recipe) {
        currentRecipe = model
        nameTextField.text = model.name
        scrollView.ingredientsTextView.text = model.ingredients
        scrollView.methodTextView.text = model.cookMethod
        scrollView.linkTextField.text = model.link
    }
    
    // MARK: - Actions
    
    @objc private func shareButtonTapped() {
        
        let recipeName = nameTextField.text ?? "-"
        let ingredients = scrollView.ingredientsTextView.text ?? "-"
        let method = scrollView.methodTextView.text ?? "-"
        
        var shareText = "Recipe Name: \(recipeName)\nIngredients: \(ingredients)\nMethod:\(method)"
        
        if let link = scrollView.linkTextField.text {
            shareText = shareText + "\nLink: \(link)"
        }
        
        let activityViewController = UIActivityViewController(activityItems: [shareText],
                                                              applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        
        isEditingMode.toggle()
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func cancelChanges() {
        
        switch mode {
        case .view:
            isEditingMode.toggle()
            view.endEditing(true)
        case .newRecipe:
            dismiss(animated: true)
        }
    }
    
    @objc private func saveButtonTapped() {
        
        switch mode {
        case .view:
            isEditingMode.toggle()
            saveChanges()
            view.endEditing(true)
        case .newRecipe:
            createNewRecipe()
            dismiss(animated: true)
        }
    }
    
    private func saveChanges() {
        if let currentRecipe = currentRecipe {
            guard let name = nameTextField.text,
                  let ingedients = scrollView.ingredientsTextView.text,
                  let method = scrollView.methodTextView.text
            else {
                return
            }
            if let link = scrollView.linkTextField.text,
               let url = URL(string: link),
               UIApplication.shared.canOpenURL(url) {
                currentRecipe.link = link
            }
            currentRecipe.name = name
            currentRecipe.ingredients = ingedients
            currentRecipe.cookMethod = method
           
            dataManager.saveContext()
        }
    }
    
    @objc func textsDidChange() {
        
        let nameText = nameTextField.text ?? ""
        let ingredientsText = scrollView.ingredientsTextView.text ?? ""
        let methodText = scrollView.methodTextView.text ?? ""
        
        guard scrollView.ingredientsTextView.isValid(with: ingredientsText),
              scrollView.methodTextView.isValid(with: methodText),
              nameTextField.isValid(with: nameText)
        else {
            changeSaveButtonState(isEnable: false)
            return
        }
        changeSaveButtonState(isEnable: true)
    }
    
    // MARK: - Private methods
    
    private func setupTextFields() {
        nameTextField.addTarget(self, action: #selector(textsDidChange), for: .editingChanged)
        scrollView.ingredientsTextView.delegate = self
        scrollView.methodTextView.delegate = self
        scrollView.linkTextField.addTarget(self, action: #selector(textsDidChange), for: .editingChanged)
    }
    
    private func changeSaveButtonState(isEnable: Bool) {
        leftButton.isEnabled = isEnable
    }
    
    private func configureView() {
        
        switch mode {
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
    
    private func createNewRecipe() {
        
        guard let name = nameTextField.text,
              let ingedients = scrollView.ingredientsTextView.text,
              let method = scrollView.methodTextView.text
        else {
            return
        }
        let newRecipe = Recipe(context: dataManager.getContext())
        if let link = scrollView.linkTextField.text,
           let url = URL(string: link),
           UIApplication.shared.canOpenURL(url) {
            newRecipe.link = link
        }
        newRecipe.id = UUID().uuidString
        newRecipe.name = name
        newRecipe.ingredients = ingedients
        newRecipe.cookMethod = method
        newRecipe.recipesGroup = currentGroup
        
        dataManager.saveContext()
    }
    
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
    
    private func setButtons(isEditing: Bool) {
        
        nameTextField.isUserInteractionEnabled = isEditing
        scrollView.setEditable(isEditing: isEditing)
        
        let leftButtonImageName = isEditing ? "saveImage" : "editImage"
        let rightButtonImageName = isEditing ? "cancelImage" : "shareImage"
        leftButton.setImage(UIImage(named: leftButtonImageName), for: .normal)
        rightButton.setImage(UIImage(named: rightButtonImageName), for: .normal)
        
        if isEditing {
            leftButton.removeTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            leftButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            rightButton.removeTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
        } else {
            leftButton.removeTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            leftButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            rightButton.removeTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
            rightButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        }
    }
    
}

// MARK: - Private extensions

extension RecipeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textsDidChange()
    }
}

extension UITextView {
    func isValid(with word: String) -> Bool {
        guard let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              text.count >= 3 else {
            return false
        }

        return true
    }
}

extension UITextField {
    func isValid(with word: String) -> Bool {
        guard let text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              text.count >= 3 else {
            return false
        }

        return true
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
