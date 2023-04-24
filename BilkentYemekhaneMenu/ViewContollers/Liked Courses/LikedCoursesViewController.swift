//
//  LikedCoursesViewController.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import UIKit
let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

let languageCode = Locale(identifier: Locale.preferredLanguages.first ?? "en").languageCode ?? "en"


class LikedCoursesViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var screenTitle: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaultsManager.shared.getAllLikedCourses().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! MealTableViewCell
        cell.backgroundColor = .clear
        cell.delegate = self
        
        let favoriteCourse = UserDefaultsManager.shared.getAllLikedCourses()[indexPath.row]
        cell.course = favoriteCourse
        cell.rowNumber = [indexPath]
        if languageCode == "tr"{
            cell.courseName.text = favoriteCourse.name
        }else{
            cell.courseName.text = favoriteCourse.englishName
        }
        
        if favoriteCourse.name.contains("Vegan") || favoriteCourse.name.contains("Vejetaryen"){
            cell.courseName.text?.append(" 🌱")
        }
        
        if UserDefaultsManager.shared.isCourseInFavorites(course: favoriteCourse){
            DispatchQueue.main.async {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
        return cell
    }
    
    @IBOutlet weak var likedCoursesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeGesture()
        setTableView()
        screenTitle.text = NSLocalizedString("likedCourses", comment: "")
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
    
    private func setTableView(){
        // Set table view data source and delegate
        likedCoursesTableView.dataSource = self

        // Register the cell nib
        let nib = UINib(nibName: "MealTableViewCell", bundle: nil)
        likedCoursesTableView.register(nib, forCellReuseIdentifier: "courseCell")
    }
}

extension LikedCoursesViewController: MealTableViewCellDelegate{
    func likeButtonTapped(for course: Course, rowNumber: [IndexPath]) {
        impactFeedbackGenerator.impactOccurred()

        var indexPathsToDelete: [IndexPath] = []
        
        for indexPath in rowNumber {
            if let cell = likedCoursesTableView.cellForRow(at: indexPath) as? MealTableViewCell {
                if UserDefaultsManager.shared.isCourseInFavorites(course: course) {
                    UserDefaultsManager.shared.addRemoveCourse(course: course)
                    likedCoursesTableView.deleteRows(at: [indexPath], with: .automatic)
                    likedCoursesTableView.reloadData()
                }
            }
        }
    }
}

