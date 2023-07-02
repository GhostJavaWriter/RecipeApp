//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Bair Nadtsalov on 30.05.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // TODO: - empty trash
        if UserDefaults.standard.object(forKey: "FirstLaunch") == nil {
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            coreDataStack.createDefaultCategories()
            NSLog("Default recipes groups created")
        } else {
            NSLog("Default recipes groups loaded")
        }
        coreDataStack.emptyTrash()
        
        let categoriesViewModel = CategoriesViewModel(coreDataStack: coreDataStack)
        let categoriesVC = CategoriesViewController(viewModel: categoriesViewModel)
        let navController = UINavigationController(rootViewController: categoriesVC)

        UINavigationBar.appearance().tintColor = Colors.CategorieItem.backgroundColor
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveViewContext()
    }
}

