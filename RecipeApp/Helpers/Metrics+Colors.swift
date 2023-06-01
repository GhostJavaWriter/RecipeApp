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
    enum Margins {
        static let directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40, leading: 40, bottom: 20, trailing: 40)
    }
}
enum Colors {
    enum CategorieItem {
        static let backgroundColor = UIColor(hex: "#758650") ?? .clear
        static let textColor = UIColor.white
        static let borderColor = UIColor.white.cgColor
    }
    static let welcomeLabelColor = UIColor.white
    static let mainBackgroundColor = UIColor(hex: "#E8B634") ?? .clear
}

enum Fonts {
    
    static let categorieItemFont = "BERNIERDistressed-Regular"
    static let welcomeLabelFont = "Annabelle"
}
