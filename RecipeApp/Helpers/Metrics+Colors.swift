//
//  Metrics.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 31.05.2023.
//

import UIKit

enum Metrics {
    
    enum CategorieItem {
        static let minimumLineSpacing: CGFloat = 21
        static let minimumInteritemSpacing: CGFloat = 21
        static let cornerRadius: CGFloat = 14
        static let borderWidth: CGFloat = 2
        static let itemSizeScale: CGFloat = 0.46
    }
    
    enum RecipeItem {
        static let cornerRadius: CGFloat = 10
    }
    
    enum Margins {
        static let screenMargins = NSDirectionalEdgeInsets(top: 40,
                                                           leading: 40,
                                                           bottom: 20,
                                                           trailing: 40)
        static let spaceBetweenCells = NSDirectionalEdgeInsets(top: 10,
                                                               leading: 10,
                                                               bottom: 10,
                                                               trailing: 10)
        static let cellContentInsets = NSDirectionalEdgeInsets(top: 10,
                                                               leading: 20,
                                                               bottom: 10,
                                                               trailing: 10)
    }
}
enum Colors {
    enum CategorieItem {
        static let backgroundColor = UIColor(hex: "#758650") ?? .clear
        static let textColor = UIColor.white
        static let borderColor = UIColor.white.cgColor
    }
    
    enum RecipeCell {
        static let backgroundColor = UIColor(hex: "#FFE27C") ?? .clear
    }
    
    static let welcomeLabelColor = UIColor.white
    static let mainBackgroundColor = UIColor(hex: "#E8B634") ?? .clear
}

enum Fonts {
    
    static let categorieItemFont = "BERNIERDistressed-Regular"
    static let welcomeLabelFont = "Annabelle"
    static let AmericanTypewriter = "AmericanTypewriter"
    
    enum Sizes {
        static let welcomeLabel: CGFloat = 52
        static let recipeName: CGFloat = 20
        static let categorieName: CGFloat = 32
    }
}
