//
//  ViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI
    
    private lazy var containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What will we cook?"
        label.textColor = .white
        label.font = UIFont(name: "Annabelle", size: 52)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Properties
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = UIColor(hex: "#E8B634")
        
        view.addSubview(containerView)
        containerView.addSubview(welcomeLabel)
        
        let margins = view.layoutMarginsGuide
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: margins.topAnchor, multiplier: 1),
            containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.25),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            
        ])
        
    }
}

