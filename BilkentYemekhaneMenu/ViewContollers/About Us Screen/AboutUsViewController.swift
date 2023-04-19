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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
