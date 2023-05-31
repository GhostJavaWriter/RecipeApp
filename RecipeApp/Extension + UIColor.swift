//
//  Extension + UIColor.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000FF) / 255
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
