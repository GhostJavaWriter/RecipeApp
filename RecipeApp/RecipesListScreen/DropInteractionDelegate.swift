//
//  DropInteractionDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 15.06.2023.
//

import UIKit

class DropInteractionDelegate: NSObject, UIDropInteractionDelegate {

    private var interactedView: UIView!
    
    init(for interactedView: UIView) {
        self.interactedView = interactedView
    }
    
    func dropInteraction(_ interaction: UIDropInteraction,
                         canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal
    {

        UIView.animate(withDuration: 0.3) {
            self.interactedView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        return UIDropProposal(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidExit session: UIDropSession) {
        UIView.animate(withDuration: 0.3) {
            self.interactedView.transform = .identity
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction,
                         performDrop session: UIDropSession) {

        UIView.animate(withDuration: 0.3) {
            self.interactedView.transform = .identity
        }

        session.loadObjects(ofClass: NSString.self) { [weak self] recipes in
            guard let self = self else { return }
            if let recipe = recipes.first as? String {
                
            } else {
                NSLog("recipe error", #function)
            }
        }
    }
}
