//
//  MealTableViewCell.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 17.04.2023.
//

import UIKit

//This protocol is used to pass the course and the row number of the cell to the delegate.
protocol MealTableViewCellDelegate: AnyObject {
    func likeButtonTapped(for course: Course, rowNumber: [IndexPath])
}

//This cell is used to display the course name and the like button.
final class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var course: Course?
    var rowNumber: [IndexPath]?
    weak var delegate: MealTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        guard let course = course else { return }
        delegate?.likeButtonTapped(for: course, rowNumber: rowNumber ?? [])
    }
}
