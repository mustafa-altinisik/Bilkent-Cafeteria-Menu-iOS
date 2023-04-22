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

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var isOnSwitch: UISwitch!
    
    var notification: SingleNotification?
    weak var delegate: NotificationsTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        guard let notification = notification else { return }
        delegate?.switchDidChangeState(for: notification)
    }
}

