//
//  AppDelegate.swift
//  Twin
//
//  Created by Burak Üstün on 13.09.2018.
//  Copyright © 2018 TWIN. All rights reserved.
//

import UIKit
import SwiftyBeaver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  weak var currentHelper:BlocklyHelper?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    SwiftyBeaver.setupConsole()
    ResourceManager.loadResources()
    handleNavigation()
    return true
  }

  func handleNavigation() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    let navController = UINavigationController(rootViewController: ProjectsViewController())
    Stylesheet.NavigationBar.clear.apply(to: navController.navigationBar)
    window?.rootViewController = navController
  }

}
