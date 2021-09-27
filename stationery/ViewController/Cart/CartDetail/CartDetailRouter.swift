//  
//  CartDetailRouter.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import Foundation

@objc protocol CartDetailRoutingLogic {
    func routeToOrder()
}

class CartDetailRouter: NSObject, CartDetailRoutingLogic {
    
    weak var viewController: CartDetailVC?
    
    // MARK: routing
    func routeToOrder() {
        viewController?.navigationController?.pushViewController(CartOrderVC.instantiate(), animated: true)
    }
}
