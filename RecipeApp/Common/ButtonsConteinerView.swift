//
//  ButtonsConteinerView.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 10.06.2023.
//

import UIKit

final class ButtonsConteinerView: UIView {
    
    private var leftButton: UIButton
    private var rightButton: UIButton
    
    init(leftButton: UIButton, rightButton: UIButton) {
        self.leftButton = leftButton
        self.rightButton = rightButton
        
        super.init(frame: .zero)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)
        addSubview(rightButton)
        
        let leadingGuide = UILayoutGuide()
        let middleGuide = UILayoutGuide()
        let trailingGuide = UILayoutGuide()
        
        addLayoutGuide(leadingGuide)
        addLayoutGuide(middleGuide)
        addLayoutGuide(trailingGuide)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: leftButton.heightAnchor, multiplier: 2),
            
            leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor),
            leadingGuide.trailingAnchor.constraint(equalTo: leftButton.leadingAnchor),
            leftButton.trailingAnchor.constraint(equalTo: middleGuide.leadingAnchor),
            middleGuide.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor),
            rightButton.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor),
            trailingGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor, multiplier: 1),
            leadingGuide.widthAnchor.constraint(equalTo: middleGuide.widthAnchor, multiplier: 1),
            middleGuide.widthAnchor.constraint(equalTo: trailingGuide.widthAnchor, multiplier: 1),
            leftButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
