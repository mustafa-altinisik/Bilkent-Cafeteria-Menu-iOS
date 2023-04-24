//
//  NotificationsManager.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    let turkishBodies = [
        "Yemek menüsü hazır! 🎉",
        "Menümüz yeni güne hazır! 🍽️",
        "Bugünkü menü hazır! 👨‍🍳",
        "Yeni menümüzü keşfedin! 🍽️",
        "Menüyü hazırladık, buyurun yemeğe! 🍴",
        "Bu günkü menümüzde neler var? 🤔",
        "Yemek saatleri yaklaştı! Menümüz hazır! 🕰️",
        "Yemek zamanı! Menüyü görmeye hazır mısınız? 🍽️",
        "Bu günkü yemeklerimiz çok lezzetli görünüyor! 🤩",
        "Bugünkü menümüzdeki yemekler sizi şaşırtacak! 😮",
        "Yemekler hazır, sofralar kuruldu! 🍽️",
        "Yemeklerimiz servise hazır! Afiyet olsun! 🍴",
        "Yemeklerimiz taze taze servise hazır! 🍅",
        "Yemek menümüzde yeni lezzetler keşfedin! 🌶️🧀🥦",
        "Bugünkü menümüzü özenle hazırladık, umarız beğenirsiniz! 🤞",
        "Yemeklerimizin tadı damağınızda kalacak! 👌",
        "Açlık krizine son! Menümüz hazır! 🍔🍟",
        "Sizler için en lezzetli yemekleri seçtik! 🍗🍖🍝",
        "Sofralarınızı şenlendirecek yemeklerimiz hazır! 🎉🎊",
        "Afiyetle yemek yiyebilmeniz için menümüz hazır! 🍲🍛",
        "Bugün hangi lezzeti denemek istersiniz? 🤔🍴",
        "Yemek menümüzü merak ediyorsanız, hemen inceleyin! 📖👀",
        "Yemeklerimiz sizi şımartacak! 🤗🍽️",
        "Menümüzdeki yemekler, usta aşçılarımızın elinden çıkma! 👨‍🍳👩‍🍳",
        "Lezzetli yemeklerimizi kaçırmayın! 🏃‍♂️🏃‍♀️💨",
        "Yemek saatleri geldi, menümüz hazır! 🕰️🍴",
        "Yemeklerimizle kendinizi ödüllendirin! 🏆🍽️",
        "Yemekler hazır, sofralar kuruldu! 🍽️",
        "Yemeklerimiz servise hazır! Afiyet olsun! 🍴",
        "Menümüzü gördünüz mü? 👀",
        "Lezzet dolu bir menü sizi bekliyor! 😋",
        "Yemek listesi güncellendi! 🆕"
    ]
    
    let englishBodies = [
        "Menu is ready! 🎉",
        "New day, new menu! 🍽️",
        "Today's menu is here! 👨‍🍳",
        "Discover our new menu! 🍽️",
        "The menu is ready, let's eat! 🍴",
        "What's on the menu today? 🤔",
        "It's mealtime! Are you ready to see the menu? 🍽️",
        "Time to eat! Are you ready to see the menu? 🍽️",
        "Today's dishes look very delicious! 🤩",
        "You'll be surprised by the dishes on today's menu! 😮",
        "Meals are ready, tables are set! 🍽️",
        "Our meals are ready to be served! Enjoy! 🍴",
        "The menu for today has arrived! 📜",
        "Today's specials are here! 🍲",
        "Fresh menu for today is ready! 🌿",
        "Treat yourself to our delicious dishes! 🍝🍔🍣",
        "Our menu is full of mouthwatering options! 🤤🍴",
        "Satisfy your cravings with our tasty meals! 😋",
        "Our chefs have prepared a delectable menu for you! 👩‍🍳👨‍🍳",
        "Enjoy a delightful meal with us today! 🥘🍲🍛",
        "The perfect meal awaits you! 🍽️😍",
        "We've got something for everyone on our menu! 🍕🥗🍱",
        "Come and try our new dishes! 🆕🍴",
        "Don't miss out on our daily specials! 🌟🍽️",
        "Our menu is guaranteed to satisfy! 😌👌",
        "Let us take care of your hunger with our delicious meals! 🙌🍲",
        "It's time to indulge in some mouthwatering food! 🤤🍔🍟",
        "Our menu is a culinary adventure waiting to be explored! 🗺️🍴",
        "Delicious food and great company await you at our restaurant! 🍽️👥"
    ]

    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var preferredLanguage = Locale(identifier: Locale.preferredLanguages.first ?? "en").language.languageCode?.identifier

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
                        
                        if notification.name == "lunch"{
                            content.title = NSLocalizedString("lunchMenu", comment: "")
                        }else{
                            content.title = NSLocalizedString("dinnerMenu", comment: "")
                        }
                        
                        if preferredLanguage == "tr"{
                            content.body = turkishBodies.randomElement() ?? ""
                        }else{
                            content.body = englishBodies.randomElement() ?? ""
                        }
                        
                        content.sound = UNNotificationSound.default
                        
                        var dateComponents = DateComponents()
                        dateComponents.hour = notification.hour
                        dateComponents.minute = notification.minute
                        dateComponents.weekday = index + 2 // shift to Monday-based week
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        
                        let identifier = "\(notification.name)-Day:\(index + 1)-Hour:\(notification.hour)-Minute:\(notification.minute)"
                        // Create the notification request
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                        
                        // Add the notification request to the notification center
                        UNUserNotificationCenter.current().add(request) { error in
                            if let error = error {
                                print("Error scheduling notification: \(error.localizedDescription)")
                            } else {
                                print("Notification scheduled successfully for: " + identifier + content.body)
                            }
                        }
                    }
                }
            }
        }
    }
}
