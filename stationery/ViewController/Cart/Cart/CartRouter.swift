//  
//  CartRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

@objc protocol CartRoutingLogic {
    func routeToCartAddress()
}

class CartRouter: NSObject, CartRoutingLogic {
    
    weak var viewController: CartVC?
    
    // MARK: routing
     func routeToCartAddress() {
        viewController?.navigationController?.pushViewController(CartAddressVC.instantiate(), animated: true)
     }
}
