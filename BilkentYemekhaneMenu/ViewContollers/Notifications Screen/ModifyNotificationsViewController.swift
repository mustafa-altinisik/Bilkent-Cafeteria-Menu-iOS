//
//  ModifyNotificationsViewController.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 21.04.2023.
//

import UIKit

class ModifyNotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NotificationsTableViewCellDelegate {
    
    var notifications = UserDefaultsManager.shared.getNotifications()
    

    func switchDidChangeState(for notification: SingleNotification) {
        UserDefaultsManager.shared.changeNotificationActivness(notification)
        refreshNotificationsScreen()
    }
    
    @objc func refreshNotificationsScreen(){
        notifications = UserDefaultsManager.shared.getNotifications()
        notificationsTable.reloadData()
        NotificationManager.shared.setScheduledNotifications()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaultsManager.shared.getNotifications()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationsTableViewCell
        cell.selectionStyle = .none
        
        
        // Get the list of notifications from UserDefaults
        if let notifications = UserDefaultsManager.shared.getNotifications() {
            // Get the notification for the current row
            let notification = notifications[indexPath.row]
            
            configure(cell: cell, for: notification)
            
            // Set the switch state to the notification's isOn value
            cell.isOnSwitch.isOn = notification.isOn
            
            var hourString = String(notification.hour)
            var minuteString = String(notification.minute)
            
            if notification.hour < 10{
                hourString = "0\(notification.hour)"
            }
            
            if notification.minute < 10{
                minuteString = "0\(notification.minute)"
            }
            
            cell.timeLabel.text = "\(hourString):\(minuteString)"
            
            var name = NSLocalizedString("lunch", comment: "")
            
            if notification.name == "dinner"{
                name = NSLocalizedString("dinner", comment: "")
            }
            var detailText = "\(name)"
            
            // Check which days are selected in the notification and add them to the detail text
            let daysOfWeek = [
                NSLocalizedString("mon", comment: ""),
                NSLocalizedString("tue", comment: ""),
                NSLocalizedString("wed", comment: ""),
                NSLocalizedString("thu", comment: ""),
                NSLocalizedString("fri", comment: ""),
                NSLocalizedString("sat", comment: ""),
                NSLocalizedString("sun", comment: "")]
            var selectedDays: [String] = []
            for i in 0..<daysOfWeek.count {
                if notification.days[i] == 1 {
                    selectedDays.append(daysOfWeek[i])
                }
            }
            
            // If all days are selected, print "Everyday"
            if selectedDays.count == 7 {
                detailText += " (\(NSLocalizedString("everyday", comment: "")))"
            }
            // If all weekdays are selected, print "Weekdays"
            else if selectedDays.count == 5 && notification.days[5] == 0 && notification.days[6] == 0 {
                detailText += " (\(NSLocalizedString("weekDays", comment: "")))"
            }
            // If Saturday and Sunday are selected, print "Weekends"
            else if selectedDays.count == 2 && notification.days[5] == 1 && notification.days[6] == 1 {
                detailText += " (\(NSLocalizedString("weekends", comment: "")))"
            }
            // Else print the selected day names
            else {
                detailText += " (\(selectedDays.joined(separator: ", ")))"
            }
            
            // Set the details label text to the detail text string
            cell.backgroundColor = .clear
            cell.detailsLabel.text = detailText
        }
        
        // Return the configured cell
        return cell
    }
    
    func configure(cell: NotificationsTableViewCell, for notification: SingleNotification) {
        cell.notification = notification
        cell.isOnSwitch.isOn = notification.isOn
        cell.delegate = self
    }
    
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var notificationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeGesture()
        screenTitle.text = NSLocalizedString("notifications", comment: "")
        setTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        notificationsTable.reloadData()
    }
    func setTable(){
        notificationsTable.dataSource = self
        notificationsTable.delegate = self
        
        let nib = UINib(nibName: "NotificationsTableViewCell", bundle: nil)
        notificationsTable.register(nib, forCellReuseIdentifier: "notificationCell")
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
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
}
