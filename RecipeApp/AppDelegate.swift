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
        
        let families = UIFont.familyNames
        families.sorted().forEach {
          print("\($0)")
          let names = UIFont.fontNames(forFamilyName: $0)
          print(names)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

