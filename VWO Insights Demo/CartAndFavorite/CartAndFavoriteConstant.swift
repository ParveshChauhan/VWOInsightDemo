//
//  CartAndFavoriteConstant.swift
//  VWO Demo
//
//  Created by Harsh Raghav on 17/01/23.
//

import Foundation

class CartAndFavoriteConstant{
    
    static var sharedInstant = CartAndFavoriteConstant()
    
    private init() { }
    
    var cartList : [Phone] = [
        Phone(name: "Redmi Y2", manufacturer: "Redmi", price: 500, image: #imageLiteral(resourceName: "Redmi Y2")),
        Phone(name: "One plus 6", manufacturer: "One plus", price: 550, image: #imageLiteral(resourceName: "One plus 6"))
        ]
    
    var favoriteList : [Phone] = [
        Phone(name: "Redmi Y2", manufacturer: "Redmi", price: 500, image: #imageLiteral(resourceName: "Redmi Y2")),
        Phone(name: "One plus 6", manufacturer: "One plus", price: 550, image: #imageLiteral(resourceName: "One plus 6"))
        ]
    
    func addToCartList(phone : Phone){
        cartList.append(phone)
    }
    
    func addToFavoriteList(phone : Phone){
        favoriteList.append(phone)
    }
    
    func deleteCart(){
        cartList.removeAll()
    }
    
    func deleteFavorite(){
        favoriteList.removeAll()
    }
}
