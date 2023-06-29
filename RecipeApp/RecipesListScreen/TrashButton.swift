//
//  TrashButton.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 2.06.2023.
//

import UIKit

final class TrashButton: UIButton {
    
    var trashButtonTapped: (() -> Void)?
    private let animationDuration = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(named: "trashButton"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        scaleIdentity()
        
        if let touch = touches.first, self.bounds.contains(touch.location(in: self)) {
            scaleIdentity()
        
            trashButtonTapped?()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        scaleIdentity()
    }
    
    private func scaleIdentity() {
        UIView.animate(withDuration: animationDuration) {
            self.transform = CGAffineTransform.identity
        }
    }
}
