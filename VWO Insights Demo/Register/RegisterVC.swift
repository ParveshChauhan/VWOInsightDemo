//
//  RegisterVC.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 15/01/23.
//

import Foundation
import UIKit
import VWO_Insights

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
           // Dismiss the keyboard
           view.endEditing(true)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "register"){
            if(checkForEmpty() && checkForSamePassword()){
                registerUserAndLogin()
//                let destination = segue.destination as! PhoneListVC
            }
        }
        else{
//            let destination = segue.destination as! LoginVC
        }
    }
    
    private func checkForEmpty() -> Bool{
        if (emailField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true || confirmPasswordField.text?.isEmpty ?? true){
            
            let alert = UIAlertController(title: "Message", message: "Username and Password fields cannot be empty!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {Timer.scheduledTimer(withTimeInterval: 5, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            
            return false
        }
        return true
    }
    
    private func checkForSamePassword() -> Bool{
        if(passwordField.text != confirmPasswordField.text){
            
            let alert = UIAlertController(title: "Message", message: "Password fields do not match!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {Timer.scheduledTimer(withTimeInterval: 5, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            
            return false
        }
        return true
    }
    
    private func registerUserAndLogin(){
 
        if let password = passwordField.text, let email = emailField.text{
            let userList = [email : password]
            
            userDefaults.set(userList, forKey: "users")
        }
        
    }
}
