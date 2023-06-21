//
//  CustomTextField.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 6.06.2023.
//

import UIKit

final class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension CustomTextField {
    
    static func makeTextField() -> CustomTextField {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Colors.RecipeCell.backgroundColor
        textField.textColor = Colors.textsViewsColor
        textField.font = UIFont(name: Fonts.AmericanTypewriter, size: 18)
        textField.layer.cornerRadius = 10
        return textField
    }
}

