//
//  ViewController.swift
//  Bilkent Yemekhane Menü
//
//  Created by Asım Altınışık on 17.04.2023.
//

import UIKit
import SideMenu
import SwiftUI
import Lottie

final class MainScreenViewController: UIViewController {
    
    @IBOutlet private weak var coursesTable: UITableView!
    @IBOutlet private weak var sideMenuButton: UIButton!
    @IBOutlet private weak var lunchButton: UIButton!
    @IBOutlet private weak var dinnerButton: UIButton!
    @IBOutlet private weak var mondayButton: UIButton!
    @IBOutlet private weak var tuesdayButton: UIButton!
    @IBOutlet private weak var wednesdayButton: UIButton!
    @IBOutlet private weak var thursdayButton: UIButton!
    @IBOutlet private weak var fridayButton: UIButton!
    @IBOutlet private weak var saturdayButton: UIButton!
    @IBOutlet private weak var sundayButton: UIButton!
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    let languageCode = Locale(identifier: Locale.preferredLanguages.first ?? "en").languageCode ?? "en"
    private var leftSideMenu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())

    static var fixedMeal: Meal?
    static var alternativeMeal: Meal?
    
    var isNoDataAnimationPut = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
        configureDayButtons()
        setTableView()
        setLeftSideMenu()
        NotificationManager.shared.setScheduledNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteCoursesButtonTapped), name: Notification.Name("PresentLikedCoursesScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSetLabelsNotification), name: Notification.Name("RefreshMainScreen"), object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        coursesTable.reloadData()
        print("App opened")
    }
    
    @IBAction func favoriteCoursesButtonTapped(_ sender: Any) {
        let likedCoursesScreen = LikedCoursesViewController()
        likedCoursesScreen.modalPresentationStyle = .fullScreen
        present(likedCoursesScreen, animated: true, completion: nil)
    }
    
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
        present(leftSideMenu, animated: true)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right{
            sideMenuButtonTapped(UIButton.self)
        }
    }
    
    private func setLeftSideMenu() {
        leftSideMenu.leftSide = true
        leftSideMenu.setNavigationBarHidden(true, animated: false)
        sideMenuButton.tintColor = .label
        let sideMenuSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        sideMenuSwipeGesture.direction = .right
        view.addGestureRecognizer(sideMenuSwipeGesture)
    }
    
    private func setButtonBorder(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
    }

    private func setBorders() {
        setButtonBorder(button: lunchButton)
        setButtonBorder(button: dinnerButton)
        setButtonBorder(button: mondayButton)
        setButtonBorder(button: tuesdayButton)
        setButtonBorder(button: wednesdayButton)
        setButtonBorder(button: thursdayButton)
        setButtonBorder(button: fridayButton)
        setButtonBorder(button: saturdayButton)
        setButtonBorder(button: sundayButton)
    }

    @IBAction func lunchButtonTapped(_ sender: Any) {
        setMenuForSelectedDay(foodType: 1)
        lunchButton.isSelected = true
        dinnerButton.isSelected = false
    }
    @IBAction func dinnerButtonTapped(_ sender: Any) {
        setMenuForSelectedDay(foodType: 2)
        dinnerButton.isSelected = true
        lunchButton.isSelected = false
    }
    @IBAction func mondayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 1, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 1)
    }
    @IBAction func tuesdayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 2, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 2)
    }
    @IBAction func wednesdayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 3, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 3)
    }
    @IBAction func thurdayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 4, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 4)
    }
    @IBAction func fridayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 5, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 5)
    }
    @IBAction func saturdayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 6, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 6)
    }
    @IBAction func sundayButtonTapped(_ sender: Any) {
        setMenuFor(dayOfTheWeek: 7, foodType: lunchButton.isSelected ? 1 : 2)
        unselectAllDayButtons(exceptTheDay: 7)
        sundayButton.isSelected = true
    }
    
    @objc func handleSetLabelsNotification() {
        unselectAllDayButtons()
        lunchButton.isSelected = false
        dinnerButton.isSelected = false
        setLabels()
    }
    
    private func setLabels(){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: Date())
        guard let weekday = components.weekday else {
            return
        }
        
        disableLunchDinnerButtonsIfNeeded(currentDay: weekday-1)
        
        switch weekday {
        case 1:
            sundayButton.isSelected = true
        case 2:
            mondayButton.isSelected = true
        case 3:
            tuesdayButton.isSelected = true
        case 4:
            wednesdayButton.isSelected = true
        case 5:
            thursdayButton.isSelected = true
        case 6:
            fridayButton.isSelected = true
        case 7:
            saturdayButton.isSelected = true
        default:
            break
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = dateFormatter.date(from: dateFormatter.string(from: Date()))!
        
        if currentTime >= dateFormatter.date(from: "00:00")! && currentTime <= dateFormatter.date(from: "14:00")! {
            lunchButton.isSelected = true
            setMenuFor(dayOfTheWeek: (weekday - 1) % 7, foodType: 1)
        } else {
            dinnerButton.isSelected = true
            setMenuFor(dayOfTheWeek: (weekday - 1) % 7, foodType: 2)
        }
        sideMenuButton.setTitle("", for: .normal)
    }
    
    private func setMenuForSelectedDay(foodType: Int) {
        guard var selectedButtonIndex = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton].firstIndex(where: { $0.isSelected }) else {
            return
        }
        if selectedButtonIndex == 0{
            selectedButtonIndex = 7
        }
        // Call the setMenuFor function with the selected day and food type
        setMenuFor(dayOfTheWeek: selectedButtonIndex, foodType: foodType)
    }

    private func unselectAllDayButtons(exceptTheDay: Int? = nil) {
        if let day = exceptTheDay {
            disableLunchDinnerButtonsIfNeeded(currentDay: day)
        }
        
        let dayButtons = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton]
        for (index, button) in dayButtons.enumerated() {
            if let day = exceptTheDay, index == day {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
        }
    }
    
    private func configureDayButtons() {
        let dayButtons = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
        var today = Calendar.current.component(.weekday, from: Date()) - 1
        
        if today == 0{
            today = 7
        }
        
        for (index, button) in dayButtons.enumerated() {
            if index + 1 < today {
                button?.tintColor = .gray
            }
        }
    }
    
    private func disableLunchDinnerButtonsIfNeeded(currentDay: Int) {
        let currentTime = Calendar.current.component(.hour, from: Date())
        var today = Calendar.current.component(.weekday, from: Date()) - 1 // Convert Sunday (1) to 0 and Monday (2) to 1, etc.
               
        if today == 0{
            today = 7
        }
        var innerCurrentDay = currentDay
        if innerCurrentDay == 0{
            innerCurrentDay = 7
        }

        if innerCurrentDay < today {
            // Selected day is before today
            lunchButton.tintColor = .gray
            dinnerButton.tintColor = .gray
        } else if currentDay == today {
            // Selected day is today
            if currentTime >= 18 {
                // Time is past 18:00, disable both buttons
                lunchButton.tintColor = .gray
                dinnerButton.tintColor = .gray
            } else if currentTime >= 14 {
                // Time is past 14:00, disable lunch button only
                lunchButton.tintColor = .gray
                dinnerButton.tintColor = .label
            } else {
                // Time is before 14:00, enable both buttons
                lunchButton.tintColor = .label
                dinnerButton.tintColor = .label
            }
        } else {
            // Selected day is after today, enable both buttons
            lunchButton.tintColor = .label
            dinnerButton.tintColor = .label
        }
    }

    private func setMenuFor(dayOfTheWeek: Int, foodType: Int){
        impactFeedbackGenerator.impactOccurred()
        
        var dayOfTheWeek = dayOfTheWeek
        
        if dayOfTheWeek == 0{
            dayOfTheWeek = 7
        }
        
        MenuManager.shared.returnMenuFor(day: dayOfTheWeek) { meals in
            if let meals = meals {
                self.removeAnimation()
                if foodType ==  1{//lunch
                    MainScreenViewController.fixedMeal = meals.lunch
                    MainScreenViewController.alternativeMeal = meals.alternative
                }else if foodType == 2{//dinner
                    MainScreenViewController.fixedMeal = meals.dinner
                    MainScreenViewController.alternativeMeal = meals.alternative
                }
                
                DispatchQueue.main.async {
                    self.coursesTable.reloadData()
                }
                
            } else {
                if !self.isNoDataAnimationPut{
                    self.putAnimation()
                }
            }
        }
    }
    
    private func putAnimation() {
        isNoDataAnimationPut = true
        let noDataFoundAnimation = LottieAnimationView(name: "noDataFound")
        
        // Set the frame of the animation to the bounds of the main view
        noDataFoundAnimation.frame = view.bounds
        noDataFoundAnimation.contentMode = .scaleAspectFit
        noDataFoundAnimation.isUserInteractionEnabled = false

        // Add the animation to the same view as the coursesTable
        view.addSubview(noDataFoundAnimation)

        // Bring the animation to the front
        view.bringSubviewToFront(noDataFoundAnimation)

        noDataFoundAnimation.loopMode = .loop
        noDataFoundAnimation.play()

        // Hide the coursesTable while the animation is displayed
        coursesTable.isHidden = true
    }


    private func removeAnimation() {
        for subview in view.subviews {
            if let animationView = subview as? LottieAnimationView {
                animationView.stop()
                animationView.removeFromSuperview()
                isNoDataAnimationPut = false
            }
        }
        // Show the coursesTable after the animation is removed
        coursesTable.isHidden = false
    }
}

extension MainScreenViewController: UITableViewDataSource{
    
    private func setTableView(){
        // Set table view data source and delegate
        coursesTable.dataSource = self

        // Register the cell nib
        let nib = UINib(nibName: "MealTableViewCell", bundle: nil)
        coursesTable.register(nib, forCellReuseIdentifier: "courseCell")
        
        let nutritionCellNib = UINib(nibName: "NutritionFactsTableViewCell", bundle: nil)
        coursesTable.register(nutritionCellNib, forCellReuseIdentifier: "nutritionFactsCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! MealTableViewCell
        cell.backgroundColor = .clear
        cell.delegate = self
        
        // Section 0: Fixed Menu
        if indexPath.section == 0 {
            if let fixedMeal = MainScreenViewController.fixedMeal,
               indexPath.row < fixedMeal.courses.count {
                let course = fixedMeal.courses[indexPath.row]
                cell.course = course
                cell.rowNumber = [indexPath]
                
                if languageCode == "tr"{
                    cell.courseName.text = course.name
                }else{
                    cell.courseName.text = course.englishName
                }
                
                // Add a "Ⓥ" character if the course name contains "Vegan"
                if course.name.contains("Vegan") || course.name.contains("Vejetaryen"){
                    cell.courseName.text?.append(" 🌱")
                }
                
                if UserDefaultsManager.shared.isCourseInFavorites(course: course){
                    DispatchQueue.main.async {
                        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                     }
                }else{
                    DispatchQueue.main.async {
                        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            } else if indexPath.row == MainScreenViewController.fixedMeal?.courses.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionFactsCell", for: indexPath) as! NutritionFactsTableViewCell
                cell.backgroundColor = .clear
    
                let fixedMeal = MainScreenViewController.fixedMeal
                let facts = fixedMeal?.nutritionFacts
                
                cell.energyLabel.text = NSLocalizedString("energy", comment: "") + String(facts?["energy"] ?? "")
                cell.carbonhydrateLabel.text = NSLocalizedString("carbohydrate", comment: "") + String(facts?["carbohydrate"] ?? "")
                cell.proteinLabel.text = NSLocalizedString("protein", comment: "") + String(facts?["protein"] ?? "")
                cell.fatLabel.text = NSLocalizedString("fat", comment: "") + String(facts?["fat"] ?? "")


                return cell
            }
        }
        
        // Section 1: Alternative Menu
        if indexPath.section == 1 {
            if let alternativeMeal = MainScreenViewController.alternativeMeal,
               indexPath.row < alternativeMeal.courses.count {
                let course = alternativeMeal.courses[indexPath.row]
                cell.course = course
                cell.rowNumber = [indexPath]
                
                if languageCode == "tr"{
                    cell.courseName.text = course.name
                }else{
                    cell.courseName.text = course.englishName
                }
                
                // Add a "Ⓥ" character if the course name contains "Vegan"
                if course.name.contains("Vegan") || course.name.contains("Vejetaryen"){
                    cell.courseName.text?.append(" 🌱")
                }
                
                if UserDefaultsManager.shared.isCourseInFavorites(course: course){
                    DispatchQueue.main.async {
                        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }else{
                    DispatchQueue.main.async {
                        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                }
            }
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // Two sections: Fixed Menu and Alternative Menu
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Section 0: Fixed Menu
        if section == 0 {
            return NSLocalizedString("fixedMenu", comment: "")
        }
        
        // Section 1: Alternative Menu
        if section == 1 {
            return NSLocalizedString("alternativeMenu", comment: "")
        }
        
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fixedCount = MainScreenViewController.fixedMeal?.courses.count,
           let alternativeCount = MainScreenViewController.alternativeMeal?.courses.count {
            
            // Section 0: Fixed Menu
            if section == 0 {
                return fixedCount + 1 //An extra cell for nutrition facts.
            }
            
            // Section 1: Alternative Menu
            if section == 1 {
                return alternativeCount
            }
        }
        
        // handle the case where one or both of the optional values are nil
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == MainScreenViewController.fixedMeal?.courses.count {
            // This is the nutrition facts cell in section 0
            return 110
        } else {
            // All other cells
            return UITableView.automaticDimension
        }
    }
}


extension MainScreenViewController: MealTableViewCellDelegate {
    func likeButtonTapped(for course: Course, rowNumber: [IndexPath]) {
        impactFeedbackGenerator.impactOccurred()
        for indexPath in rowNumber {
            if let cell = coursesTable.cellForRow(at: indexPath) as? MealTableViewCell {
                UserDefaultsManager.shared.addRemoveCourse(course: course)
                let newImage = cell.likeButton.currentImage == UIImage(systemName: "heart.fill") ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
                UIView.transition(with: cell.likeButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    cell.likeButton.setImage(newImage, for: .normal)
                }, completion: nil)
            }
        }
    }
}

