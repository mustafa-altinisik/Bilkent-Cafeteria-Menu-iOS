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

    private init() {}

    func returnMenuFor(day: Int, completion: @escaping (Menu?) -> Void) {
        if let cachedMenu = cachedMenu {
            // If menu is already cached, return the menu for the given day from the cache
            guard day >= 1 && day <= cachedMenu.count else {
                completion(nil)
                return
            }
            completion(cachedMenu[day - 1])
        } else {
            // If menu is not cached, fetch it from the network
            NetworkManager.shared.fetchMenu { [weak self] menu, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching menu: \(error)")
                    completion(nil)
                } else if let menu = menu {
                    self.cachedMenu = menu
                    completion(menu[day - 1])
                }
            }
        }
    }
}

