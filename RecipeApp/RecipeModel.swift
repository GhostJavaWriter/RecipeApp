//
//  RecipeModel.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 11.06.2023.
//

import UIKit
import UniformTypeIdentifiers

final class RecipeModel: NSObject, Codable, NSItemProviderReading, NSItemProviderWriting {
    
    // MARK: - NSItemProviderReading, NSItemProviderWriting
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [(UTType.utf8PlainText.identifier) as String]
    }
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [(UTType.utf8PlainText.identifier) as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> RecipeModel {
        let decoder = JSONDecoder()
        do {
            let myJSON = try decoder.decode(RecipeModel.self, from: data)
            return myJSON
        } catch {
            fatalError("Err")
        }
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
        
        let progress = Progress(totalUnitCount: 100)
                
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: String.Encoding.utf8)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return progress
    }
    
    // MARK: - Properties
    
    let name: String
    let ingredients: String
    let method: String
    let link: String?
    
    // MARK: - Init
    
    init(name: String, ingredients: String, method: String, link: String?) {
        self.name = name
        self.ingredients = ingredients
        self.method = method
        self.link = link
    }
}
