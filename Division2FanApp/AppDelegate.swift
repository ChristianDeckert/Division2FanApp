//
//  AppDelegate.swift
//  Division2FanApp
//
//  Created by Christian on 15.03.19.
//  Copyright © 2019 Christian Deckert. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  static var shared: AppDelegate! {
    return UIApplication.shared.delegate as? AppDelegate
  }

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      UINavigationBar.appearance().titleTextAttributes = [
        .font: UIFont.bordaHeading
    ]
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RootViewController()
    window?.tintColor = .primaryTint
    window?.makeKeyAndVisible()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    NotificationCenter.default.post(name: NSNotification.Name.applicationDidBecomeActive, object: nil)
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}

extension NSNotification.Name {
  static let applicationDidBecomeActive = NSNotification.Name(rawValue: "applicationDidBecomeActive")
}
