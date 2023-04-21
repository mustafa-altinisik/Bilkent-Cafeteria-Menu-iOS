//
//  LikedCoursesViewController.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 20.04.2023.
//

import UIKit

var preferredLanguage = Locale(identifier: Locale.preferredLanguages.first ?? "en").language.languageCode?.identifier


class LikedCoursesViewController: UIViewController, UITableViewDataSource, MealTableViewCellDelegate {
    @IBOutlet weak var screenTitle: UILabel!
    func likeButtonTapped(for course: Course, rowNumber: [IndexPath]) {
        //
    }
    
    let favoriteCourses = UserDefaultsManager.shared.getAllLikedCourses()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! MealTableViewCell
        cell.backgroundColor = .clear
        cell.delegate = self
        
        var favoriteCourse = favoriteCourses[indexPath.row]
        cell.course = favoriteCourse
        cell.rowNumber = [indexPath]
        if preferredLanguage == "tr"{
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
        // Do any additional setup after loading the view.
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
