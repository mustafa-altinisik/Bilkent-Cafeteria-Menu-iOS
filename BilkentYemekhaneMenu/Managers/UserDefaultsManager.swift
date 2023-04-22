//
//  UserDefaultsManager.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import Foundation

class UserDefaultsManager{
    
    static let shared = UserDefaultsManager() // create a static instance variable
    private init() { }
    
    func addRemoveCourse(course: Course) {
        var likedCourses = UserDefaults.standard.array(forKey: "likedCourses") as? [Data] ?? []
        
        if let index = likedCourses.firstIndex(where: { data in
            guard let decodedCourse = try? JSONDecoder().decode(Course.self, from: data) else { return false }
            return decodedCourse.id == course.id
        }) {
            likedCourses.remove(at: index)
        } else {
            let encodedCourse = try? JSONEncoder().encode(course)
            if let encodedCourse = encodedCourse {
                likedCourses.append(encodedCourse)
            }
        }
        UserDefaults.standard.set(likedCourses, forKey: "likedCourses")
    }
    
    func isCourseInFavorites(course: Course) -> Bool {
        let likedCourses = UserDefaults.standard.array(forKey: "likedCourses") as? [Data] ?? []
        
        if let courseData = try? JSONEncoder().encode(course),
           let index = likedCourses.firstIndex(of: courseData) {
            return true
        } else {
            return false
        }
    }
    
    func getAllLikedCourses() -> [Course] {
        let decoder = JSONDecoder()
        let likedCourseData = UserDefaults.standard.array(forKey: "likedCourses") as? [Data] ?? []
        
        var likedCourses: [Course] = []
        for courseData in likedCourseData {
            if let course = try? decoder.decode(Course.self, from: courseData) {
                likedCourses.append(course)
            }
        }
        return likedCourses
    }

    
    func getNotifications() -> [SingleNotification]? {
        guard let notificationData = UserDefaults.standard.array(forKey: "notifications") as? [[String: Any]] else {
            return nil
        }
        
        if notificationData.isEmpty {
            return nil
        }
        
        var notifications: [SingleNotification] = []
        
        for data in notificationData {
            guard let name = data["name"] as? String,
                  let hour = data["hour"] as? Int,
                  let minute = data["minute"] as? Int,
                  let days = data["days"] as? [Int],
                  let isOn = data["isOn"] as? Bool else {
                continue
            }
            
            let notification = SingleNotification(name: name, hour: hour, minute: minute, days: days, isOn: isOn)
            notifications.append(notification)
        }
        
        return notifications
    }
    
    func checkIfAppLaunchedForTheFirstTime() -> Bool {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "isAppLaunchedForTheFirstTime") {
            return false
        } else {
            userDefaults.set(true, forKey: "isAppLaunchedForTheFirstTime")
            return true
        }
    }
    
    func addNotification(_ notification: SingleNotification) {
        if !checkNotification(notification) {
            var notifications = getNotifications() ?? []
            notifications.append(notification)
            setNotifications(notifications)
        }
    }
    
    func checkNotification(_ notification: SingleNotification) -> Bool {
        guard let notifications = getNotifications() else {
            return false
        }
        for existingNotification in notifications {
            if existingNotification == notification {
                return true
            }
        }
        return false
    }
    
    func setNotifications(_ notifications: [SingleNotification]) {
        let notificationData = notifications.map { notification in
            return [
                "name": notification.name,
                "hour": notification.hour,
                "minute": notification.minute,
                "days": notification.days,
                "isOn": notification.isOn
            ]
        }
        UserDefaults.standard.set(notificationData, forKey: "notifications")
    }
    
    func changeNotificationActivness(_ notification: SingleNotification) {
        guard var notifications = getNotifications(),
              let index = notifications.firstIndex(of: notification) else {
            return
        }
        
        let updatedNotification = SingleNotification(
            name: notification.name,
            hour: notification.hour,
            minute: notification.minute,
            days: notification.days,
            isOn: !notification.isOn // toggle the value of isOn
        )
        
        removeNotification(notification)
        addNotification(updatedNotification)
    }
    
    func removeNotification(_ notification: SingleNotification) {
        guard var notifications = getNotifications() else {
            return
        }
        
        if let index = notifications.firstIndex(of: notification) {
            notifications.remove(at: index)
            setNotifications(notifications)
        }
    }
}
