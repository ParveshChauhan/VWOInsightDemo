//
//  FavoriteList.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 17/01/23.
//

import UIKit
import VWO_Insights

class FavoriteList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sortPhoneAlphabetically: (Phone, Phone) -> Bool {
        return { a, b in
            return a.name.lowercased() < b.name.lowercased()
        }
    }
    
    @IBAction func HamburgerAction(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("")
    }

    @IBAction func deleteTapped(_ sender: Any) {
        CartAndFavoriteConstant.sharedInstant.deleteFavorite()
        self.tableView.reloadData()
    }
}

extension FavoriteList: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartAndFavoriteConstant.sharedInstant.favoriteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell") as! PhoneCellView
        let currentPhone = CartAndFavoriteConstant.sharedInstant.favoriteList[indexPath.row]
        cell.phoneImageField.image = currentPhone.image
        cell.titleLabelField.text = currentPhone.name
        cell.subTitleLabelField.text = "by \(currentPhone.manufacturer)"

        return cell
    }
}
