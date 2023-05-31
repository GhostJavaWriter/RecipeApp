//
//  ViewController.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private lazy var welcomeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.adjustsFontForContentSizeCategory = true
//        label.text = "What will\n we cook?"
//        label.textColor = .white
//        label.numberOfLines = 0
//        return label
//    }()
    
    // MARK: - Properties
    
//    var fontName = "Annabelle" {
//        didSet {
//            scaledFont = ScaledFont(fontName: fontName)
//            configureFont()
//        }
//    }
//
//    private lazy var scaledFont: ScaledFont = {
//        return ScaledFont(fontName: fontName)
//    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }

    // MARK: - Private methods
    
    private func configureView() {
        
        view.backgroundColor = UIColor(hex: "#E8B634")
        
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
//    private func configureFont() {
//        welcomeLabel.font = scaledFont.font(forTextStyle: .largeTitle)
//    }

}

