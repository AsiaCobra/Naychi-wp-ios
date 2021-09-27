//  
//  CartAddressRouter.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import Foundation

@objc protocol CartAddressRoutingLogic {
    func routeToBillingDetail()
}

class CartAddressRouter: NSObject, CartAddressRoutingLogic {
    
    weak var viewController: CartAddressVC?
    
    // MARK: routing
    func routeToBillingDetail() {
        viewController?.navigationController?.pushViewController(CartDetailVC.instantiate(), animated: true)
    }
}
