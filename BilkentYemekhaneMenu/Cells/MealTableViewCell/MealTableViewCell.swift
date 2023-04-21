//
//  MealTableViewCell.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 17.04.2023.
//

import UIKit

protocol MealTableViewCellDelegate: AnyObject {
    func likeButtonTapped(for course: Course, rowNumber: [IndexPath])
}

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var course: Course?
    var rowNumber: [IndexPath]?
    weak var delegate: MealTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let course = course else { return }
        delegate?.likeButtonTapped(for: course, rowNumber: rowNumber ?? [])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
