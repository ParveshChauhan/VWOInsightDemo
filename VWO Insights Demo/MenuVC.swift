//
//  MenuVC.swift
//  VWODemoApp
//
//  Created by Kaunteya Suryawanshi on 25/07/17.
//  Copyright © 2017-2022 Wingify. All rights reserved.
//

import UIKit
//import VWO

enum HamburgerMenuItem: String {
    case profile = "My Profile"
    case buyPhone = "Products Search"
    case searchProperty = "Property"
    case browser = "Browser"
    case cartList = "Cart"
    case favoriteList = "Favorites"
    case crashTest = "Crash Test"
    case stopRecording = "Stop Recording Sessions"
    static var all: [HamburgerMenuItem] {
        return [.profile, .buyPhone, .searchProperty, .browser,.cartList, .favoriteList, .crashTest,.stopRecording]
    }
}

protocol HamburgerMenuDelegate: AnyObject {
    func selectedMenuItem(item: HamburgerMenuItem)
}

class MenuVC : UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: HamburgerMenuDelegate?
    var isInitiale = true
    @IBAction func actionCloseMenu(_ sender: Any) {
        self.slideMenuController()?.closeLeft()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !UserDefaults.standard.bool(forKey: "ProfileT") && UserDefaults.standard.bool(forKey: "MenuOpenedT"){
            let showcase = MaterialShowcase()
            showcase.setTargetView(tableView: tableView, section: 0, row: 0)
            showcase.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
            showcase.primaryText = "Profile"
            showcase.secondaryText = "You can see the profile which have multiple insights option."
            showcase.show(completion: {
                UserDefaults.standard.set(true, forKey: "ProfileT")
//                self.showStopRecordingPrompt()
            })
        }else if !UserDefaults.standard.bool(forKey: "StopRecordingT") && UserDefaults.standard.bool(forKey: "CrashT"){
                showStopRecordingPrompt()
            
        }
        isInitiale = false
    }
    
    func showStopRecordingPrompt(){
        if !UserDefaults.standard.bool(forKey: "StopRecordingT") && !isInitiale{
            let showcase = MaterialShowcase()
            showcase.setTargetView(tableView: tableView, section: 0, row: 7)
            showcase.backgroundPromptColor = #colorLiteral(red: 0.1568627451, green: 0.6588235294, blue: 0.8901960784, alpha: 1)
            showcase.primaryText = "Stop Session Recording"
            showcase.secondaryText = "Click here to stop session recording that is in progress"
            showcase.show(completion: {
                UserDefaults.standard.set(true, forKey: "StopRecordingT")
            })
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
//        print("disapper called for menuvc")
        
    }
}

//MARK: - UITableViewDataSource
extension MenuVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HamburgerMenuItem.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        cell.textLabel?.text = HamburgerMenuItem.all[indexPath.row].rawValue
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.slideMenuController()?.closeLeft()
        if(HamburgerMenuItem.all[indexPath.row].rawValue == "Stop Session Recording"){
            self.tableView.cellForRow(at: indexPath)?.alpha = 0.3
            self.tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = false
        }
        delegate?.selectedMenuItem(item: HamburgerMenuItem.all[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
