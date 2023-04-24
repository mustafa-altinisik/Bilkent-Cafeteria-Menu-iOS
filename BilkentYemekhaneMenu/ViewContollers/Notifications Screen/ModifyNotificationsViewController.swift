//
//  ModifyNotificationsViewController.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 21.04.2023.
//

import UIKit

final class ModifyNotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NotificationsTableViewCellDelegate {
    
    // MARK: - Properties
    var notifications = UserDefaultsManager.shared.getNotifications()
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var notificationsTable: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeGesture()
        screenTitle.text = NSLocalizedString("notifications", comment: "")
        setTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        notificationsTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource
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
        }
        
        // Return the configured cell
        return cell
    }

    // MARK: - NotificationsTableViewCellDelegate
    func switchDidChangeState(for notification: SingleNotification) {
        UserDefaultsManager.shared.changeNotificationActivness(notification)
        refreshNotificationsScreen()
    }
    
    // MARK: - Private Methods
    private func configure(cell: NotificationsTableViewCell, for notification: SingleNotification) {
        cell.notification = notification
        cell.isOnSwitch.isOn = notification.isOn
        cell.delegate = self
        
        var hourString = String(notification.hour)
        var minuteString = String(notification.minute)
        
        if notification.hour < 10 {
            hourString = "0\(notification.hour)"
        }
        
        if notification.minute < 10 {
            minuteString = "0\(notification.minute)"
        }
        
        cell.timeLabel.text = "\(hourString):\(minuteString)"
        
        var name = NSLocalizedString("lunch", comment: "")
        
        if notification.name == "dinner" {
            name = NSLocalizedString("dinner", comment: "")
        }
        
        var detailText = "\(name)"
        detailText += generateDaysDescription(notification: notification)
        
        cell.backgroundColor = .clear
        cell.detailsLabel.text = detailText
    }
    
    private func generateDaysDescription(notification: SingleNotification) -> String {
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
        
        if selectedDays.count == 7 {
            return " (\(NSLocalizedString("everyday", comment: "")))"
        } else if selectedDays.count == 5 && notification.days[5] == 0 && notification.days[6] == 0 {
            return " (\(NSLocalizedString("weekDays", comment: "")))"
        } else if selectedDays.count == 2 && notification.days[5] == 1 && notification.days[6] == 1 {
            return " (\(NSLocalizedString("weekends", comment: "")))"
        } else {
            return " (\(selectedDays.joined(separator: ", ")))"
        }
    }
    
    @objc private func refreshNotificationsScreen() {
        notifications = UserDefaultsManager.shared.getNotifications()
        notificationsTable.reloadData()
        NotificationManager.shared.setScheduledNotifications()
    }
    
    private func setTable() {
        notificationsTable.dataSource = self
        notificationsTable.delegate = self
        
        let nib = UINib(nibName: "NotificationsTableViewCell", bundle: nil)
        notificationsTable.register(nib, forCellReuseIdentifier: "notificationCell")
    }
    
    private func setSwipeGesture() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc private func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .right {
            backButtonTapped(UIButton.self)
        }
    }
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
