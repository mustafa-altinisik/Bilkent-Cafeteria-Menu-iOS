//
//  MealTableViewCell.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 17.04.2023.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var courseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
