//
//  MenuManager.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import Foundation

class MenuManager {
    static let shared = MenuManager()

    private var cachedMenu: [Menu]?
    private var menuExpirationDate: Date?

    private init() {}


    func returnMenuFor(day: Int, completion: @escaping (Menu?) -> Void) {
        let now = Date()
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
                    let expirationDate = Calendar.current.date(byAdding: .hour, value: 1, to: now)!
                    self.menuExpirationDate = expirationDate
                    self.cachedMenu = menu
                    completion(menu[day - 1])
                }
            }
        }
    }

}

