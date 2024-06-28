//
//  SettingVC.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 17/01/23.
//

import Foundation
import UIKit
import VWO_Insights

class SettingVC: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func showAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Title", message: "How many columns to show in grid?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            _ = alert.textFields![0] as UITextField
        }
        alert.addTextField { (textField) in
        textField.placeholder = "ex: 0"
        }
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
    }
    
    @IBAction func openContactURL(_ sender: Any) {
        if let url = URL(string: "https://vwo.com/contact-us/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
