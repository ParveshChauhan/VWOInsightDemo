//
//  DetailsVC.swift
//  VWODemoApp
//
//  Created by Kaunteya Suryawanshi on 28/07/17.
//  Copyright © 2017-2022 Wingify. All rights reserved.
//

import UIKit
import VWO_Insights

class PhoneDetailVC: UIViewController {

    @IBOutlet weak var phoneImageHandle: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var phone: Phone!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewForPhone()
        navigationItem.title = phone.name

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        VWO.stopSessionRecording()
      
    }

    private func updateViewForPhone() {
        nameLabel.text = phone.name
        phoneImageHandle.image = phone.image
        priceLabel.text = "$\(phone.price)"
    }

    @IBAction func actionBuy(_ sender: Any) {

    }
    
    @IBAction func actionCart(_ sender: Any) {
        CartAndFavoriteConstant.sharedInstant.addToCartList(phone: phone)
        
      
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        CartAndFavoriteConstant.sharedInstant.addToFavoriteList(phone: phone)
       
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
//        VWO.startSessionRecording()
    }
    
}
