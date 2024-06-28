//
//  CartList.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 17/01/23.
//

import UIKit
import VWO_Insights

class CartList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    private var sortPhoneAlphabetically: (Phone, Phone) -> Bool {
//        return { a, b in
//            return a.name.lowercased() < b.name.lowercased()
//        }
//    }

    @IBAction func HamburgerAction(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteTapped(_ sender: Any) {
        CartAndFavoriteConstant.sharedInstant.deleteCart()
        self.tableView.reloadData()
    }
}

extension CartList: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartAndFavoriteConstant.sharedInstant.cartList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell") as! PhoneCellView
        let currentPhone = CartAndFavoriteConstant.sharedInstant.cartList[indexPath.row]
        cell.phoneImageField.image = currentPhone.image
        cell.titleLabelField.text = currentPhone.name
        cell.subTitleLabelField.text = "by \(currentPhone.manufacturer)"

        return cell
    }
    
    
}
