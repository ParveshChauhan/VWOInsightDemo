//
//  LoginVC.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 15/01/23.
//

import Foundation
import UIKit
import VWO_Insights

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var startStopRecordingButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var APIKeyBtn: UIButton!
    
    let userDefaults = UserDefaults.standard
    let scanVC = ScannerViewController()
    
    override func viewDidLoad() {
        scanVC.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(openScanner), name: Notification.Name("SCanner"), object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
           // Dismiss the keyboard
           view.endEditing(true)
       }
    
    func showPrompt(btn : UIButton, primaryText : String,SecondaryText:String) {
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(button: btn, tapThrough: true)
        showcase.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
        showcase.primaryText = primaryText
        showcase.secondaryText = SecondaryText
        showcase.show(completion: {
            UserDefaults.standard.set(true, forKey: "APIKeyT")
        })
        
        
        
    }
    func showStratRecPrompt() {
        
        let showcase = MaterialShowcase()
        showcase.setTargetView(button: startStopRecordingButton, tapThrough: true)
        showcase.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
        showcase.primaryText = "Start Session recording"
        showcase.secondaryText = "You can click here to start session recording "
        showcase.delegate = self
        showcase.show(completion: {
                        UserDefaults.standard.set(true, forKey: "StartRecT")
            //            self.showLoginPrompt()
        })
    }
    
    func showLoginPrompt() {
        if UserDefaults.standard.bool(forKey: "StartedRecT") && !UserDefaults.standard.bool(forKey: "LoginT"){
            let showcase1 = MaterialShowcase()
            showcase1.setTargetView(button: LoginButton, tapThrough: true)
            showcase1.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
            showcase1.primaryText = "Great!"
            showcase1.secondaryText = "The recording has now started. You can now perform events like 'Single tab', 'Double tab', 'Scroll'. Please click here to continue"
            showcase1.show(completion: {
                            UserDefaults.standard.set(true, forKey: "LoginT")
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if !UserDefaults.standard.bool(forKey: "APIKeyT"){
            self.showPrompt(btn: self.APIKeyBtn, primaryText: "API Key\n", SecondaryText: "Please click here to add Account Id and API Key")
        }else  if UserDefaults.standard.bool(forKey: "APIKeyT") && !UserDefaults.standard.bool(forKey: "StartRecT") && UserDefaults.standard.bool(forKey: "APIVaildT"){
            showStratRecPrompt()
            
        }else if UserDefaults.standard.bool(forKey: "StartedRecT") && !UserDefaults.standard.bool(forKey: "LoginT"){
            showLoginPrompt()
            UserDefaults.standard.set(true, forKey: "LoginT")
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(APIKeyManager.checkSDKStatus()){
            self.startStopRecordingButton.setTitle("Stop Recording", for: .normal)
            self.LoginButton.isUserInteractionEnabled = true
            self.LoginButton.alpha = 1
        }
        else{
            self.startStopRecordingButton.setTitle("Start Recording", for: .normal)
            self.LoginButton.isUserInteractionEnabled = false
            self.LoginButton.alpha = 0.3
        }
        if(!APIKeyManager.checkSavedAccountDetails()){
            self.startStopRecordingButton.isHidden = true
        }
        
    }
    
    @objc func openScanner(_ notification: Notification) {
        
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "login"){
            if(checkForEmpty()){
                _ = checkUserValidation()
                //                let destination = segue.destination as! PhoneListVC
            }
            //            let destination = segue.destination as! PhoneListVC
        }
        //        else{
        //            let destination = segue.destination as! RegisterVC
        //        }
    }
    
    @IBAction func startStopRecording(_ sender: Any) {
        if(APIKeyManager.checkSDKStatus()){
            UserDefaults.standard.set(DemoConstants.VWOSessionRecordingStopped, forKey: DemoConstants.VWOSessionRecordingStatus)
            UserDefaults.standard.set(true, forKey: "StartedRecT")
            VWO.stopSessionRecording()
            self.startStopRecordingButton.setTitle("Start Recording", for: .normal)
            self.LoginButton.isUserInteractionEnabled = false
            self.LoginButton.alpha = 0.3
            self.showLoginPrompt()
        }
        else{
            let VWOAccountID = UserDefaults.standard.string(forKey: DemoConstants.VWOAccountID)
            let VWOApiKey = UserDefaults.standard.string(forKey: DemoConstants.VWOApiKey)
            
            if(VWOApiKey != nil && VWOAccountID != nil){
                VWO.configure(accountId:VWOAccountID!, appId: VWOApiKey! , userId: "", completion: {
                    result in
                    switch result{
                        
                    case .success(_):
                        print("VWO launch Success")
                        UserDefaults.standard.set(true, forKey: "StartedRecT")
                        VWO.startSessionRecording()
                        UserDefaults.standard.set(DemoConstants.VWOSessionRecordingRunning, forKey: DemoConstants.VWOSessionRecordingStatus)
                        self.startStopRecordingButton.setTitle("Stop Recording", for: .normal)
                        self.LoginButton.isUserInteractionEnabled = true
                        self.LoginButton.alpha = 1
                        self.showLoginPrompt()
                    case .failure(_):
                        print("VWO launch Failure")
                    }
                })
            }
        }
    }
    
    @IBAction func goToPhoneList(_ sender: Any) {
        //
        //        let menuVC = UIStoryboard.main.instantiate(identifier: "menuVC") as MenuVC
        //        let phoneNav = UIStoryboard.main.instantiate(identifier: "phoneNav") as UINavigationController
        //
        //        let slideMenuController = SlideMenuController(mainViewController: phoneNav, leftMenuViewController: menuVC)
        
        //        menuVC.delegate = self
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        appDelegate.setPhoneVC()
        
        //        menuVC.delegate = self
        //        window?.rootViewController = slideMenuController
        //        window?.makeKeyAndVisible()
        
        
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let newViewController = storyBoard.instantiateViewController(withIdentifier: "phoneNav")
        //
        //        newViewController.modalPresentationStyle = .fullScreen
        //        slideMenuController.modalPresentationStyle = .fullScreen
        //
        //        self.present(slideMenuController, animated: true, completion: nil)
    }
    
    @IBAction func EnterValues(_ sender: Any) {
        APIKeyManager.showAlert{ success in
            // Handle the completion result
            if success {
                self.startStopRecordingButton.isHidden = false
            } else {
                self.startStopRecordingButton.isHidden = true
            }
        }
    }
    private func checkForEmpty() -> Bool{
        if (emailField.text?.isEmpty ?? true || passwordField.text?.isEmpty ?? true){
            
            let alert = UIAlertController(title: "Message", message: "Username and Password fields cannot be empty!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    private func checkUserValidation() -> Bool{
        
        if(userDefaults.object(forKey: "users") == nil){
            userDefaults.set(NSDictionary(), forKey: "users")
        }
        let userList : NSDictionary = userDefaults.object(forKey: "users") as! NSDictionary
        
        if let value = userList.object(forKey: emailField.text!) as! String?{
            if(value == passwordField.text){
                return true
            }
        }
        else{
            let alert = UIAlertController(title: "Message", message: "Username and Password fields do not match to any existing user", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {Timer.scheduledTimer(withTimeInterval: 5, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
        }
        return false
    }
    
    deinit {
//        print("deinit called for login")
        //        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginVC : MaterialShowcaseDelegate{
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        if UserDefaults.standard.bool(forKey: "StartedRecT") && !UserDefaults.standard.bool(forKey: "LoginT"){
            self.showLoginPrompt()
        }
    }
}

extension LoginVC : scannerDelegate{
    func getQRCode(code: String) {
        let separatedStrings = code.components(separatedBy: ",")

        if separatedStrings.count >= 2 {
            let ApiKey = separatedStrings[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let AccountId = separatedStrings[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            UserDefaults.standard.set(ApiKey, forKey: DemoConstants.VWOApiKey)
            UserDefaults.standard.set(AccountId, forKey: DemoConstants.VWOAccountID)
            APIKeyManager.showAlert{ success in
                // Handle the completion result
                if success {
                    self.startStopRecordingButton.isHidden = false
                } else {
                    self.startStopRecordingButton.isHidden = true
                }
            }
        }
        
    }
}
