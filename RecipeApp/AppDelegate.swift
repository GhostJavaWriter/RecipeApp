//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let dataManager = RecipesDataManager()
        let categoriesVC = CategoriesViewController(dataManager: dataManager)
        let navController = UINavigationController(rootViewController: categoriesVC)
        UINavigationBar.appearance().tintColor = Colors.CategorieItem.backgroundColor
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }

}

