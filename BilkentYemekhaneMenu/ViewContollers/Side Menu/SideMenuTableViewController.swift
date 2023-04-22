//
//  SideMenuTableViewController.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 19.04.2023.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    struct categoriesWithSystemImageNamesStruct {
        var categoryId: Int
        var categoryNameToBeDisplayed: String
        var categoryIcon: String
    }
    
    enum LanguageOption: String {
        case turkish = "Türkçe"
        case english = "English"
    }
    var preferredLanguage = Locale(identifier: Locale.preferredLanguages.first ?? "en").language.languageCode?.identifier

    let categoriesWithImages: [[categoriesWithSystemImageNamesStruct]] = [
            [
                categoriesWithSystemImageNamesStruct(categoryId: 0, categoryNameToBeDisplayed: NSLocalizedString("likedCourses", comment: ""), categoryIcon: "heart"),
            ],
            [
                categoriesWithSystemImageNamesStruct(categoryId: 1, categoryNameToBeDisplayed: NSLocalizedString("notifications", comment: ""), categoryIcon: "bell"),
                categoriesWithSystemImageNamesStruct(categoryId: 2, categoryNameToBeDisplayed: NSLocalizedString("darkMode", comment: ""), categoryIcon: "paintbrush"),
                categoriesWithSystemImageNamesStruct(categoryId: 3, categoryNameToBeDisplayed: NSLocalizedString("language", comment: ""), categoryIcon: "globe"),
            ],
            [
                categoriesWithSystemImageNamesStruct(categoryId: 4, categoryNameToBeDisplayed: NSLocalizedString("aboutUs", comment: ""), categoryIcon: "person.2")
            ]
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SideMenuPredefinedCategoryTVC.self, forCellReuseIdentifier: "predefinedCategoryCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categoriesWithImages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesWithImages[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "predefinedCategoryCell", for: indexPath) as! SideMenuPredefinedCategoryTVC
        let category = categoriesWithImages[indexPath.section][indexPath.row]

        cell.categoryButton.setTitle(category.categoryNameToBeDisplayed, for: .normal)
        cell.categoryButton.setTitleColor(.label, for: .normal) // Set text color to label color
        cell.categoryButton.setImage(UIImage(systemName: category.categoryIcon), for: .normal)
        cell.selectionStyle = .none // Disable selection color
        
        switch category.categoryId {
        case 2:
            let notificationSwitch = UISwitch()
            notificationSwitch.isOn = false
            notificationSwitch.alpha = 1.0 // set alpha to 1.0 to make it appear as if it is enabled
            if self.traitCollection.userInterfaceStyle == .dark{
                DispatchQueue.main.async {
                    notificationSwitch.isOn = true
                }
            }
            notificationSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            cell.accessoryView = notificationSwitch
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesWithImages[indexPath.section][indexPath.row]
        switch category.categoryId {
        case 0:
            let likedCoursesScreen = LikedCoursesViewController()
            likedCoursesScreen.modalPresentationStyle = .fullScreen
            present(likedCoursesScreen, animated: true, completion: nil)
        case 1:
            let notificationsScreen = ModifyNotificationsViewController()
            notificationsScreen.modalPresentationStyle = .fullScreen
            present(notificationsScreen, animated: true, completion: nil)
        case 3:
            let alertController = UIAlertController(title: NSLocalizedString("chooseALanguage", comment: ""), message: NSLocalizedString("appRestartMessage", comment: ""), preferredStyle: .actionSheet)
            if preferredLanguage == "tr" {
                let action = UIAlertAction(title: LanguageOption.english.rawValue, style: .default) { _ in
                    self.setLanguage("en")
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
                    exit(0)

                }
                alertController.addAction(action)
            } else {
                let action = UIAlertAction(title: LanguageOption.turkish.rawValue, style: .default) { _ in
                    self.setLanguage("tr")
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
                    exit(0)
                }
                alertController.addAction(action)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        case 4:
            let aboutUsScreen = AboutUsViewController()
            aboutUsScreen.modalPresentationStyle = .fullScreen
            present(aboutUsScreen, animated: true, completion: nil)
        default:
            break
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " "
        case 1:
            return NSLocalizedString("settings", comment: "")
        case 2:
            return NSLocalizedString("extras", comment: "")
        default:
            return nil
        }
    }
    
    private func setLanguage(_ language: String) {
        let defaults = UserDefaults.standard
        defaults.set([language], forKey: "AppleLanguages")
        defaults.synchronize()
        
        // Restart the app to apply the language change
        exit(EXIT_SUCCESS)
    }
    
//    @objc func switchValueDidChange(_ sender: UISwitch) {
//        if sender.isOn {
//            // Set app theme to dark
//            UIApplication.shared.windows.forEach { window in
//                window.overrideUserInterfaceStyle = .dark
//            }
//        } else {
//            // Set app theme to light
//            UIApplication.shared.windows.forEach { window in
//                window.overrideUserInterfaceStyle = .light
//            }
//        }
//    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        let animationDuration: TimeInterval = 0.3
        UIView.transition(
            with: view,
            duration: animationDuration,
            options: [.transitionCrossDissolve],
            animations: {
                if sender.isOn {
                    // Set app theme to dark
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                } else {
                    // Set app theme to light
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                }
            },
            completion: nil
        )
    }

}
