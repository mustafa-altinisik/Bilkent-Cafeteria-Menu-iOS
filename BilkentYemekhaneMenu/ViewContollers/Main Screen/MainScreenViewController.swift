//
//  ViewController.swift
//  Bilkent Yemekhane Menü
//
//  Created by Asım Altınışık on 17.04.2023.
//

import UIKit

class MainScreenViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        configureDayButtons()
        NetworkManager.shared.fetchMenu { menu, error in
            if let error = error {
                print("Error fetching menu: \(error)")
            } else if let menu = menu {
                print("Menu: \(menu[0].alternative.courses[0].name)")
            }
        }
    }
    
    private func setBorders(){
        lunchButton.layer.borderWidth = 1.0
        lunchButton.layer.borderColor = UIColor.black.cgColor
        lunchButton.layer.cornerRadius = 5.0
        
        dinnerButton.layer.borderWidth = 1.0
        dinnerButton.layer.borderColor = UIColor.black.cgColor
        dinnerButton.layer.cornerRadius = 5.0
        
        mondayButton.layer.borderWidth = 1.0
        mondayButton.layer.borderColor = UIColor.black.cgColor
        mondayButton.layer.cornerRadius = 5.0
        
        tuesdayButton.layer.borderWidth = 1.0
        tuesdayButton.layer.borderColor = UIColor.black.cgColor
        tuesdayButton.layer.cornerRadius = 5.0
        
        wednesdayButton.layer.borderWidth = 1.0
        wednesdayButton.layer.borderColor = UIColor.black.cgColor
        wednesdayButton.layer.cornerRadius = 5.0
        
        thursdayButton.layer.borderWidth = 1.0
        thursdayButton.layer.borderColor = UIColor.black.cgColor
        thursdayButton.layer.cornerRadius = 5.0
        
        fridayButton.layer.borderWidth = 1.0
        fridayButton.layer.borderColor = UIColor.black.cgColor
        fridayButton.layer.cornerRadius = 5.0
        
        saturdayButton.layer.borderWidth = 1.0
        saturdayButton.layer.borderColor = UIColor.black.cgColor
        saturdayButton.layer.cornerRadius = 5.0
        
        sundayButton.layer.borderWidth = 1.0
        sundayButton.layer.borderColor = UIColor.black.cgColor
        sundayButton.layer.cornerRadius = 5.0
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

    private func unselectAllDayButtons(exceptTheDay: Int){
        disableLunchDinnerButtonsIfNeeded(currentDay: exceptTheDay)
        let dayButtons = [sundayButton,mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton]
        for (index, button) in dayButtons.enumerated() {
            if index == exceptTheDay {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
        }
    }
    
    private func configureDayButtons() {
        let dayButtons = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        
        for (index, button) in dayButtons.enumerated() {
            if index + 1 < today {
                button?.tintColor = .gray
            }
        }
    }
    
    private func disableLunchDinnerButtonsIfNeeded(currentDay: Int) {
        let currentTime = Calendar.current.component(.hour, from: Date())
        let today = Calendar.current.component(.weekday, from: Date()) - 1 // Convert Sunday (1) to 0 and Monday (2) to 1, etc.

        if currentDay < today {
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
                dinnerButton.tintColor = .black
            } else {
                // Time is before 14:00, enable both buttons
                lunchButton.tintColor = .black
                dinnerButton.tintColor = .black
            }
        } else {
            // Selected day is after today, enable both buttons
            lunchButton.tintColor = .black
            dinnerButton.tintColor = .black
        }
    }

    private func setMenuFor(dayOfTheWeek: Int, foodType: Int){
        //Takes day of the week. Monday is 1, sunday is 7.
        //Takes foodType. Lunch is 1, dinner is 2.
        print("Day: " + String(dayOfTheWeek))
        print("Food type: " + String(foodType))
    }
}

