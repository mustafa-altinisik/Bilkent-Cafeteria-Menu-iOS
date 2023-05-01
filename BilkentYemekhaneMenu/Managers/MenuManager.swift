//
//  MenuManager.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import Foundation
import WidgetKit

// A class to manage menu data
final class MenuManager {
    // Singleton instance of MenuManager
    static let shared = MenuManager()

    // Private variables for caching menu data
    private var cachedMenu: [Menu]?
    private var menuExpirationDate: Date?

    // Private initializer to ensure only one instance is created
    private init() {}

    // Function to return the menu for the given day
    func returnMenuFor(day: Int, completion: @escaping (Menu?) -> Void) {
        let now = Date()
        
        // Check if the cached menu is still valid and not expired
        if let cachedMenu = cachedMenu, let expirationDate = menuExpirationDate, now < expirationDate {
            // If menu is already cached and has not expired, return the menu for the given day from the cache
            guard day >= 1 && day <= cachedMenu.count else {
                completion(nil)
                return
            }
            completion(cachedMenu[day - 1])
        } else {
            // If menu is not cached or has expired, fetch it from the network
            NetworkManager.shared.fetchMenu { [weak self] menu, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching menu: \(error)")
                    completion(nil)
                } else if let menu = menu {
                    // Cache the fetched menu and set its expiration date
                    let expirationDate = Calendar.current.date(byAdding: .hour, value: 1, to: now)!
                    self.menuExpirationDate = expirationDate
                    self.cachedMenu = menu
                    
                    if day - 1 > menu.count{
                        // Return the menu for the requested day
                        completion(menu[day - 1])
                    } else{
                        // No menu for selected meal.
                        completion(nil)
                    }
                    
                }
            }
        }
    }
    
    func refreshWidget() {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
