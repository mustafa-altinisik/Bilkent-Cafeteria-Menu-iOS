//
//  NotificationsTableViewCell.swift
//  Daily Hadiths
//
//  Created by Asım Altınışık on 8.04.2023.
//

import UIKit

protocol NotificationsTableViewCellDelegate: AnyObject {
    func switchDidChangeState(for notification: SingleNotification)
}

//This cell is used to display the notification name, days and time and a switch to turn the notification on or off.
final class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var isOnSwitch: UISwitch!
    
    var notification: SingleNotification?
    weak var delegate: NotificationsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //The function is used to turn the notification on or off.
    @IBAction func switchValueChanged(_ sender: Any) {
        guard let notification = notification else { return }
        delegate?.switchDidChangeState(for: notification)
    }
}

