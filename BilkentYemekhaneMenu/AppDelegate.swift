import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // Create a unique 16-character hexadecimal ID for the user if not already set
    func createUniqueId() {
        if UserDefaults.standard.string(forKey: "uniqueId") == nil {
            let uniqueId = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16)
            UserDefaults.standard.set(String(uniqueId), forKey: "uniqueId")
        }
    }

    // Called when the application finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
        center.delegate = self
        
        // If notifications are not set and the app is launched for the first time, add default notifications
        if UserDefaultsManager.shared.getNotifications() == nil && UserDefaultsManager.shared.checkIfAppLaunchedForTheFirstTime() {
    
            UserDefaultsManager.shared.addNotification(SingleNotification(name: "lunch", hour: 11, minute: 30, days: [1, 1, 1, 1, 1, 1, 1], isOn: true))
            UserDefaultsManager.shared.addNotification(SingleNotification(name: "dinner", hour: 16, minute: 30, days: [1, 1, 1, 1, 1, 1, 1], isOn: true))
        }
        
        // Schedule notifications
        NotificationManager.shared.setScheduledNotifications()

        // Create unique ID for the user if not already set
        createUniqueId()

        return true
    }

    // MARK: UISceneSession Lifecycle

    // Configure new scene sessions
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // Handle discarded scene sessions
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
