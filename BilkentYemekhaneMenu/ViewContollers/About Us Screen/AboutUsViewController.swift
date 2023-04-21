//
//  AboutUsViewController.swift
//  BilkentYemekhaneMenu
//
//  Created by Asım Altınışık on 19.04.2023.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var githubLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeGesture()
        githubLabel.setTitle(NSLocalizedString("thisAppIsAnOpenSourceProject", comment: ""), for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func githubButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://github.com/mustafa-altinisik/Bilkent-Cafeteria-Menu-iOS") {
            UIApplication.shared.open(url)
        }
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
