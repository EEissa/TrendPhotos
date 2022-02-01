//
//  AppDelegate.swift
//  Photos
//
//  Created by Essam on 01/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRoot()
        return true
    }
    
    func setRoot()  {
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: TRPhotosListViewController())
        window?.makeKeyAndVisible()
    }
}

