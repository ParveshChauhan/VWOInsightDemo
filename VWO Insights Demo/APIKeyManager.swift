//
//  APIKeyManager.swift
//  VWO Demo
//
//  Created by Kaunteya Suryawanshi on 24/07/18.
//  Copyright © 2018-2022 Wingify. All rights reserved.
//

import UIKit
import SCLAlertView
import VWO_Insights

/// Handles stuff that is to be done when user clicks on "Enter API Key"
struct APIKeyManager {
    static func showAlert(completion: @escaping (Bool) -> Void) {
        
        let alert = SCLAlertView(
            appearance: SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width
            )
        )
        
        let exitAlert = SCLAlertView(
            appearance: SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width,
                showCloseButton: false
            )
        )
        exitAlert.addButton("OK", backgroundColor: UIColor.black){
            exit(0)
        }
        
        
        
        let APIkeytextField: UITextField = alert.addTextField("Enter API key")
        let AccountIDtextField: UITextField = alert.addTextField("Enter Account ID")
        APIkeytextField.text = getAPIKeyForPlaceholder(placeHolderKey: "VWOApiKey")
        AccountIDtextField.text = getAPIKeyForPlaceholder(placeHolderKey: "VWOAccountID")
        
        
        
        let btn =  alert.addButton("Scan QR", backgroundColor: UIColor.black) {
            NotificationCenter.default.post(name:Notification.Name("SCanner"), object: nil)
        }
        
       
        
        alert.addButton("Save and Exit", backgroundColor: UIColor.black) {
            let VWOAccountID = AccountIDtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let VWOApiKey = APIkeytextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if _isValid(apiKey: VWOApiKey, accountID: VWOAccountID) {
                //save keys and Quit the application
                
                UserDefaults.standard.set(VWOApiKey, forKey: DemoConstants.VWOApiKey)
                UserDefaults.standard.set(VWOAccountID, forKey: DemoConstants.VWOAccountID)
                
                exitAlert.showNotice("Please relaunch the application", subTitle: "")
                completion(true)
                UserDefaults.standard.set(true, forKey: "APIVaildT")
            } else {
                completion(false)
                SCLAlertView().showError("Key error", subTitle: "")
            }
        }
        alert.showNotice("Launch VWO" , subTitle: "You need to launch this application once again after you click on 'Save and Exit'", closeButtonTitle: "Cancel")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            
            if !UserDefaults.standard.bool(forKey: "QRT"){
                        let showcase = MaterialShowcase()
                        showcase.setTargetView(button:btn , tapThrough: true)
                        showcase.backgroundPromptColor =  #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
                        showcase.primaryText = "Scan QR"
                        showcase.secondaryText = "Scan QR for autofill AccoundId and API key."
                        showcase.show(completion: {
                            UserDefaults.standard.set(true, forKey: "QRT")
                        })
                    }
        })
        
    }
    
    
    /// Tries to find if there is a valid API key in clipboard or Xcode launch parameters
    static func getAPIKeyForPlaceholder(placeHolderKey: String) -> String? {
        
        
        // Xcode launch parameters
        if let value = UserDefaults.standard.string(forKey: placeHolderKey) {
            return value
        }

//        if let clipboard = UIPasteboard.general.string {
//            if clipboard.count == 32{
//                return clipboard
//            }
//         }
        return nil
    }
    
    ///Key must be in format `[32Chars]-[NUMS]`
    static private func _isValid(apiKey: String, accountID: String) -> Bool {
        
        guard Int(accountID) != nil else{
            return false
        }
        guard apiKey.count == 32 else {
            return false
        }
        return true
    }
    
    static func checkSavedAccountDetails() -> Bool{
        let VWOAccountID = UserDefaults.standard.string(forKey: DemoConstants.VWOAccountID)
        let VWOApiKey = UserDefaults.standard.string(forKey: DemoConstants.VWOApiKey)
        
        if(VWOApiKey != nil && VWOAccountID != nil){
            return true
        }
        return false
    }
    
    static func checkSDKStatus() -> Bool{
        let VWOSessionRecordingStatus = UserDefaults.standard.string(forKey: DemoConstants.VWOSessionRecordingStatus)
        
        if(VWOSessionRecordingStatus != nil && VWOSessionRecordingStatus == DemoConstants.VWOSessionRecordingRunning){
            return true
        }
        return false
    }
    
}
