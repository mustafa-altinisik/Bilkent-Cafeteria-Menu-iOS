//
//  NotificatonDetailsViewController.swift
//  Daily Hadiths
//
//  Created by Asım Altınışık on 8.04.2023.
//

import UIKit

class NotificationDetailsViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var notificationTimePicker: UIDatePicker!
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var sundayLabel: UILabel!
    

    
    var notificationToBeModified: SingleNotification?
    var isPresentedToModify: Bool = false
    var isOnValue: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeGesture()
        setLabels()
        setTimePicker()

        if notificationToBeModified != nil{
            setAsModificationScreen()
            isPresentedToModify = true
            isOnValue = ((notificationToBeModified?.isOn) != nil)
        }
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setTimePicker(){
        if notificationToBeModified?.name == "lunch"{
            notificationTimePicker.minimumDate = Calendar.current.date(bySettingHour: 00, minute: 0, second: 0, of: Date())
            notificationTimePicker.maximumDate = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())
        }else{
            notificationTimePicker.minimumDate = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date())
            notificationTimePicker.maximumDate = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())
        }
    }

    @IBAction func timePickerValueChanged(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Get the notification from the form
        let notification = getSingleNotification()

        // Check if the notification is the same as the one being modified
        if notification == notificationToBeModified {
            let alert = UIAlertController(title: NSLocalizedString("savedWithNoModification", comment: ""), message: NSLocalizedString("savedWithNoModificationDetail", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else if notification.days == [0, 0, 0, 0, 0, 0, 0] {
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("selectAtLeastOneDay", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if UserDefaultsManager.shared.checkNotification(notification) {
            var message = NSLocalizedString("notificationExistsDetail", comment: "")
            if isPresentedToModify {
                message = NSLocalizedString("modifiedNotificationExistsDetail", comment: "")
            }
            let alert = UIAlertController(title: NSLocalizedString("notificationExists", comment: ""), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if let notification = notificationToBeModified {
                UserDefaultsManager.shared.removeNotification(notification)
            }
            UserDefaultsManager.shared.addNotification(notification)
            dismiss(animated: true)
        }
    }


    @IBAction func mondayButtonTapped(_ sender: Any) {
        if mondayButton.isSelected {
            mondayButton.isSelected = false
            mondayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            mondayButton.isSelected = true
            mondayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func tuesdayButtonTapped(_ sender: Any) {
        if tuesdayButton.isSelected {
            tuesdayButton.isSelected = false
            tuesdayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            tuesdayButton.isSelected = true
            tuesdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func wednesdayButtonTapped(_ sender: Any) {
        if wednesdayButton.isSelected {
            wednesdayButton.isSelected = false
            wednesdayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            wednesdayButton.isSelected = true
            wednesdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func thursdayButtonTapped(_ sender: Any) {
        if thursdayButton.isSelected {
            thursdayButton.isSelected = false
            thursdayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            thursdayButton.isSelected = true
            thursdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func fridayButtonTapped(_ sender: Any) {
        if fridayButton.isSelected {
            fridayButton.isSelected = false
            fridayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            fridayButton.isSelected = true
            fridayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func saturdayButtonTapped(_ sender: Any) {
        if saturdayButton.isSelected {
            saturdayButton.isSelected = false
            saturdayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            saturdayButton.isSelected = true
            saturdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func sundayButtonTapped(_ sender: Any) {
        if sundayButton.isSelected {
            sundayButton.isSelected = false
            sundayButton.setImage(UIImage(systemName: "circle")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            sundayButton.isSelected = true
            sundayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    func setSwipeGesture() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .right {
            backButtonTapped(UIButton.self)
        }
    }
    
    func setLabels(){
        header.text = NSLocalizedString("notificationDetails", comment: "")
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        mondayLabel.text = NSLocalizedString("Mon", comment: "")
        tuesdayLabel.text = NSLocalizedString("Tue", comment: "")
        wednesdayLabel.text = NSLocalizedString("Wed", comment: "")
        thursdayLabel.text = NSLocalizedString("Thu", comment: "")
        fridayLabel.text = NSLocalizedString("Fri", comment: "")
        saturdayLabel.text = NSLocalizedString("Sat", comment: "")
        sundayLabel.text = NSLocalizedString("Sun", comment: "")

    }
    
    func setAsModificationScreen() {
        header.text = NSLocalizedString("modifyNotification", comment: "")
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        if let notification = notificationToBeModified {
            dateComponents.hour = notification.hour
            dateComponents.minute = notification.minute
            
            // Set the state and image of the days buttons based on the notification object
            mondayButton.isSelected = notification.days[0] == 1
            mondayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
            
            tuesdayButton.isSelected = notification.days[1] == 1
            tuesdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
            
            wednesdayButton.isSelected = notification.days[2] == 1
            wednesdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
            
            thursdayButton.isSelected = notification.days[3] == 1
            thursdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
            
            fridayButton.isSelected = notification.days[4] == 1
            fridayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .selected)
            
            saturdayButton.isSelected = notification.days[5] == 1
            saturdayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
            
            sundayButton.isSelected = notification.days[6] == 1
            sundayButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        }
        
        let date = calendar.date(from: dateComponents) ?? Date()
        notificationTimePicker.date = date
        
    }
 
    func getSingleNotification() -> SingleNotification {
        // Get the selected days of the week
        let daysOfWeek = [
            mondayButton.isSelected ? 1 : 0,
            tuesdayButton.isSelected ? 1 : 0,
            wednesdayButton.isSelected ? 1 : 0,
            thursdayButton.isSelected ? 1 : 0,
            fridayButton.isSelected ? 1 : 0,
            saturdayButton.isSelected ? 1 : 0,
            sundayButton.isSelected ? 1 : 0
        ]

        // Get the selected time from the picker
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationTimePicker.date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0


        // Create and return a SingleNotification object
        return SingleNotification(name: notificationToBeModified?.name ?? "", hour: hour, minute: minute, days: daysOfWeek, isOn: isOnValue)
    }
}
