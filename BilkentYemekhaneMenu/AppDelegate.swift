//
//  AppDelegate.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 17.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
        center.delegate = self
        
        if UserDefaultsManager.shared.getNotifications() == nil && UserDefaultsManager.shared.checkIfAppLaunchedForTheFirstTime(){
    
            UserDefaultsManager.shared.addNotification(SingleNotification(name: "lunch", hour: 11, minute: 30, days: [1, 1, 1, 1, 1, 0, 0], isOn: true))
            UserDefaultsManager.shared.addNotification(SingleNotification(name: "dinner", hour: 16, minute: 30, days: [1, 1, 1, 1, 1, 0, 0], isOn: true))
        }
        
        NotificationManager.shared.setScheduledNotifications()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

