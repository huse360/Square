//
//  AppDelegate.swift
//  Square
//
//  Created by huse on 23/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
               
        ios14NavBar()
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: SquareViewController())
        return true
    }
    
    func ios14NavBar() {
        //https://stackoverflow.com/questions/69111478/ios-15-navigation-bar-transparent
        // White non-transucent navigation bar, supports dark appearance
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }

}

