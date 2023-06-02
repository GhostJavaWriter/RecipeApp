//
//  TrashButton.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 2.06.2023.
//

import UIKit

final class TrashButton: UIButton {
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        scaleIdentity()
        
        if let touch = touches.first, self.bounds.contains(touch.location(in: self)) {
            scaleIdentity()
        
            print("button aciton")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        scaleIdentity()
    }
    
    private func scaleIdentity() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}
