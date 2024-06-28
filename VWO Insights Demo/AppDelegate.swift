//
//  AppDelegate.swift
//  VWO Demo
//
//  Created by Kaunteya Suryawanshi on 29/09/17.
//  Copyright © 2017-2022 Wingify. All rights reserved.
//

import UIKit
import VWO_Insights
import SCLAlertView
import Firebase
import FirebaseCore
import FirebaseCrashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, VWOIntegrationCallback {

    var window: UIWindow?

    let menuVC = UIStoryboard.main.instantiate(identifier: "menuVC") as MenuVC
    let profileNav = UIStoryboard.main.instantiate(identifier: "profileNav") as UINavigationController
    let phoneNav = UIStoryboard.main.instantiate(identifier: "phoneNav") as UINavigationController
    let browserNav = UIStoryboard.main.instantiate(identifier: "browser") as UINavigationController
    let houseNav = UIStoryboard.main.instantiate(identifier: "houseNav") as UINavigationController
    let CartNav = UIStoryboard.main.instantiate(identifier: "CartCheck") as UINavigationController
    let FavoriteNav = UIStoryboard.main.instantiate(identifier: "FavoriteNav") as UINavigationController
    let CrashTestViewController = UIStoryboard.main.instantiate(identifier: "CrashTestViewController") as UINavigationController
    
    let loginNav = UIStoryboard.main.instantiate(identifier: "loginNav") as UINavigationController

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
                

        VWO.enableLog(logLevel: .all)

        if(!APIKeyManager.checkSDKStatus()){
            setCurrentViewController(vc: loginNav)
            return true
        }

        
        let VWOAccountID = UserDefaults.standard.string(forKey: DemoConstants.VWOAccountID)
        let VWOApiKey = UserDefaults.standard.string(forKey: DemoConstants.VWOApiKey)
        
        if(VWOApiKey != nil && VWOAccountID != nil){
            VWO.configure(accountId:VWOAccountID!, appId: VWOApiKey! , userId: "", completion: {
                result in
                switch result{
                
                case .success(_):
                    print("VWO launch Success")
//                    print("Last Exception \(ELExceptionLogger.lastExceptionDetails() ?? "nothing captured")")
                    VWO.startSessionRecording()
                case .failure(_):
                    print("VWO launch Failure")
                }
            })
        }
        
        setCurrentViewController(vc: loginNav)
        return true
    }

    func setCurrentViewController(vc: UIViewController) {
        let slideMenuController = SlideMenuController(mainViewController: vc, leftMenuViewController: menuVC)
        menuVC.delegate = self
        window?.rootViewController = slideMenuController
        window?.makeKeyAndVisible()
    }
    
    public func setPhoneVC(){
        setCurrentViewController(vc: loginNav)
    }
    
    public func checkAndStopSessionRecording(){
        if(APIKeyManager.checkSDKStatus()){
            let exitAlert = SCLAlertView(
                appearance: SCLAlertView.SCLAppearance(
                    kWindowWidth: UIScreen.main.bounds.width
                    
                )
            )
            exitAlert.addButton("Yes"){
                UserDefaults.standard.set(DemoConstants.VWOSessionRecordingStopped, forKey: DemoConstants.VWOSessionRecordingStatus)
                VWO.stopSessionRecording()
            }
            
            exitAlert.showNotice("Are you sure you want to stop?" , subTitle: "", closeButtonTitle: "Cancel")
        }
    }
    
    func onVWOIntegrationCompleted(integrations: [IntegrationsList]) {
            for integration in integrations {
                let sessionURL = VWO.getSessionURL(source: integration)
                if(sessionURL == nil){
                    print("Session URL could not be generated - VWO Insights is not initialized. Please ensure that VWO Insights is properly initialized before attempting to generate the session URL. Refer to the documentation for initialization instructions.")
                    return
                }
                
                switch integration {
                    case IntegrationsList.CRASHLYTICS :
                        let crashlyticsReference = Crashlytics.crashlytics()
                        crashlyticsReference.setCustomValue(sessionURL, forKey: "VWOSessionURL")
                        
                    @unknown default:
                        print("Unsupported Integration enum!")
                }
            }
        }
}

extension AppDelegate: HamburgerMenuDelegate {
    func selectedMenuItem(item: HamburgerMenuItem) {
        switch item {
        case .buyPhone: setCurrentViewController(vc: phoneNav)

        case .searchProperty: setCurrentViewController(vc: houseNav)
            
        case .browser: setCurrentViewController(vc: browserNav)

        case .profile:setCurrentViewController(vc: profileNav)
            
        case .cartList:setCurrentViewController(vc: CartNav)
            
        case .favoriteList:setCurrentViewController(vc: FavoriteNav)
            
        case .crashTest: setCurrentViewController(vc: CrashTestViewController)
            
        case .stopRecording:
            checkAndStopSessionRecording()
        }
    }
}
