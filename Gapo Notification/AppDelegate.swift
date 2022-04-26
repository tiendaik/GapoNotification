//
//  AppDelegate.swift
//  Gapo Notification
//
//  Created by Tiennh on 4/26/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    private let listNotificationVC = ListNotificationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = listNotificationVC
        window?.makeKeyAndVisible()
        
        return true
    }


}

