import UIKit

class SideMenuTableViewController: UITableViewController {
    
    // Struct for storing information about each category
    struct CategoryWithSystemImageName {
        var categoryId: Int
        var categoryNameToBeDisplayed: String
        var categoryIcon: String
    }
    
    enum LanguageOption: String {
        case turkish = "Türkçe"
        case english = "English"
    }
    
    let languageCode = Locale(identifier: Locale.preferredLanguages.first ?? "en").languageCode ?? "en"
    
    // Define categories with their images and details
    let categoriesWithImages: [[CategoryWithSystemImageName]] = [
        [
            CategoryWithSystemImageName(categoryId: 0, categoryNameToBeDisplayed: NSLocalizedString("likedCourses", comment: ""), categoryIcon: "heart"),
        ],
        [
            CategoryWithSystemImageName(categoryId: 1, categoryNameToBeDisplayed: NSLocalizedString("notifications", comment: ""), categoryIcon: "bell"),
            CategoryWithSystemImageName(categoryId: 2, categoryNameToBeDisplayed: NSLocalizedString("darkMode", comment: ""), categoryIcon: "paintbrush"),
            CategoryWithSystemImageName(categoryId: 3, categoryNameToBeDisplayed: NSLocalizedString("language", comment: ""), categoryIcon: "globe"),
        ],
        [
            CategoryWithSystemImageName(categoryId: 4, categoryNameToBeDisplayed: NSLocalizedString("aboutUs", comment: ""), categoryIcon: "person.2")
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SideMenuPredefinedCategoryTVC.self, forCellReuseIdentifier: "predefinedCategoryCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesWithImages.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesWithImages[section].count
    }
    
    // Configure the cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "predefinedCategoryCell", for: indexPath) as! SideMenuPredefinedCategoryTVC
        let category = categoriesWithImages[indexPath.section][indexPath.row]
        
        cell.categoryButton.setTitle(category.categoryNameToBeDisplayed, for: .normal)
        cell.categoryButton.setTitleColor(.label, for: .normal)
        cell.categoryButton.setImage(UIImage(systemName: category.categoryIcon), for: .normal)
        cell.selectionStyle = .none
        
        if category.categoryId == 2 { // Dark Mode cell
            configureDarkModeSwitch(for: cell)
        }
        
        return cell
    }
    
    // Configure the Dark Mode switch
    private func configureDarkModeSwitch(for cell: SideMenuPredefinedCategoryTVC) {
        let darkModeSwitch = UISwitch()
        darkModeSwitch.isOn = self.traitCollection.userInterfaceStyle == .dark
        darkModeSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        cell.accessoryView = darkModeSwitch
    }
    
    // MARK: - Table view delegate
    
    // Handle the selection of each cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesWithImages[indexPath.section][indexPath.row]
        switch category.categoryId {
        case 0: // Liked Courses Screen
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: Notification.Name("PresentLikedCoursesScreen"), object: nil)
        case 1: // Notifications Screen
            presentFullScreen(ModifyNotificationsViewController())
        case 3: // Change Language
            presentLanguageAlert()
        case 4: // About Us Screen
            presentFullScreen(AboutUsViewController())
        default:
            break
        }
    }
    
    // Helper function to present a view controller in full screen
    private func presentFullScreen(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    // Present language change alert
    private func presentLanguageAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("chooseALanguage", comment: ""), message: NSLocalizedString("appRestartMessage", comment: ""), preferredStyle: .actionSheet)
        
        if languageCode == "tr" {
            let action = UIAlertAction(title: LanguageOption.english.rawValue, style: .default) { _ in
                self.setLanguage("en")
                self.restartApp()
            }
            alertController.addAction(action)
        } else {
            let action = UIAlertAction(title: LanguageOption.turkish.rawValue, style: .default) { _ in
                self.setLanguage("tr")
                self.restartApp()
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
    
    // Set the app language and restart the app
    private func setLanguage(_ language: String) {
        let defaults = UserDefaults.standard
        defaults.set([language], forKey: "AppleLanguages")
        guard let sharedDefaults = UserDefaults(suiteName: "group.altinisik.mustafa.BilkentYemekhaneMenu") else { return }
        sharedDefaults.set(language, forKey: "SelectedLanguage")
        sharedDefaults.synchronize()
        MenuManager.shared.updateLanguageAndRefreshWidget()
        defaults.synchronize()
    }
    
    private func restartApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        exit(0)
    }
    
    // Handle the value change of the Dark Mode switch
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
