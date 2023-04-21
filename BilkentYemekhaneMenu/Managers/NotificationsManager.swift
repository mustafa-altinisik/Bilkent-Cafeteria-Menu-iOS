//
//  NotificationsManager.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    

    func setScheduledNotifications() {
        // Remove previously set notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Get the array of notifications from UserDefaults
        guard let notifications = UserDefaultsManager.shared.getNotifications() else {
            return
        }
        
        // Get the current date and calendar
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        for notification in notifications {
            if notification.isOn{
                for (index, day) in notification.days.enumerated() {
                    if day == 1 {
                        // Create the notification content
                        let content = UNMutableNotificationContent()
                        content.title = NSLocalizedString("dailyHadith", comment: "")
                        content.body = notification.name
                        content.sound = UNNotificationSound.default
                        
                        var dateComponents = DateComponents()
                        dateComponents.hour = notification.hour
                        dateComponents.minute = notification.minute
                        dateComponents.weekday = index + 2 // shift to Monday-based week
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        
                        let identifier = "\(notification.name)-Day:\(index + 1)-Hour:\(notification.hour)-Minute:\(notification.minute)"
                        // Create the notification request
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        
                        // Add the notification request to the notification center
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("Error scheduling notification: \(error.localizedDescription)")
                            } else {
                                print("Notification scheduled successfully for: " + identifier)
                            }
                        }
                    }
                }
            }
        }
    }
}
