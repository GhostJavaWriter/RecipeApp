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
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let dataManager = RecipesDataManager()
        dataManager.emptyTrash()
        let categoriesVC = CategoriesViewController(dataManager: dataManager)
        let navController = UINavigationController(rootViewController: categoriesVC)
        
        if UserDefaults.standard.object(forKey: "FirstLaunch") == nil {
            UserDefaults.standard.set(true, forKey: "FirstLaunch")
            dataManager.createDefaultCategories()
            NSLog("Default recipes group created")
        } else {
            NSLog("Default recipes group loaded")
        }

        UINavigationBar.appearance().tintColor = Colors.CategorieItem.backgroundColor
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

