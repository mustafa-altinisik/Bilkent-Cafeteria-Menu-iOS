//
//  NutritionFactsTableViewCell.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 19.04.2023.
//

import UIKit

final class NutritionFactsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var carbonhydrateLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
