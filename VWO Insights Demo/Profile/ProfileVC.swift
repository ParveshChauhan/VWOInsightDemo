//
//  ProfileVC.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 16/01/23.
//

import Foundation
import UIKit
import VWO_Insights

class ProfileVC: UIViewController {
    
    @IBOutlet weak var AnrBtn: UIButton!
    @IBOutlet weak var crashBtn: UIButton!
    @IBOutlet weak var profileBg: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let sequence = MaterialShowcaseSequence()
    let userDefaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           
           let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
           view.addGestureRecognizer(longPressGesture)
           
           let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoomInOut(_:) ))
           profileBg.addGestureRecognizer(pinch)
       }
    
    override func viewDidAppear(_ animated: Bool) {
       
        if !UserDefaults.standard.bool(forKey: "ANRT"){
            let showcase = MaterialShowcase()
            showcase.setTargetView(button: AnrBtn , tapThrough: false)
            showcase.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
            showcase.primaryText = "Application Not Responding(A.N.R)"
            showcase.secondaryText = "Click here to trigger A.N.R event."
            showcase.show(completion: {
//                UserDefaults.standard.set(true, forKey: "ANRT")
                //                self.showCrashprompt()
            })
            //        }
            
            let showcase1 = MaterialShowcase()
            showcase1.setTargetView(button: crashBtn , tapThrough: false)
            showcase1.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
            showcase1.primaryText = "Crash"
            showcase1.secondaryText = "Click here to trigger Crash event."
            showcase1.show(completion: {
//            UserDefaults.standard.set(true, forKey: "CrashT")
                //                self.showCrashprompt()
            })
            
            showcase.delegate = self
            showcase1.delegate = self
            
            sequence.temp(showcase).temp(showcase1).start()
        }
    }
    
  
    
       @objc func didLongPress(){
           //long pressed
       }

       @objc func zoomInOut(_ gesture : UIPinchGestureRecognizer){
           print(" scale in view controller \(gesture.scale)")
           print("............. ............ zoomInOut ....        ..............")
       }
       
    
    @IBOutlet weak var humburgerAction: UINavigationItem!
    
    
    @IBAction func humbergerClickAction(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    @IBAction func createANR(_ sender: Any) {
        //create ANR
        while(true){
            //just ANR
        }
    }
    @IBAction func createCrash(_ sender: Any) {
        //MARK: For checking crash logs
        let exception = NSException(name: NSExceptionName(rawValue: "arbitrary"), reason: "arbitrary reason", userInfo: nil)
        exception.raise()
//        var a = [Int]()
//        _ = a[0]
    }
    
    @IBAction func createSyncVisitorPropEvent(_ sender: Any) {
            var dict = Dictionary<String, Any>()
            dict["harshattr"] = "raghav"
            dict["price"] = 21
//            dict["bool"] = true
//            dict["map"] = ["Map inside": "Map outside"]
            VWO.triggerSyncVisitorPropEvent(visitorData: dict)
            VWO.triggerCustomEvent(customEventName: "swapnilevent", customData: dict)
        }
}
extension ProfileVC: MaterialShowcaseDelegate {
    func showCaseDidDismiss(showcase: MaterialShowcase, didTapTarget: Bool) {
        sequence.showCaseWillDismis()
        UserDefaults.standard.set(true, forKey: "ANRT")
        UserDefaults.standard.set(true, forKey: "CrashT")
    }
}
