//  
//  CartOrderRouter.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import Foundation

protocol CartOrderRoutingLogic {
    func routeToComplete(data: OrderResponse)
}

class CartOrderRouter: NSObject, CartOrderRoutingLogic {
    
    weak var viewController: CartOrderVC?
    
    // MARK: routing
    func routeToComplete(data: OrderResponse) {
        let vc = OrderCompleteVC.instantiate()
//        viewController?.navigationController?.pushFromBottom(vc)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        vc.navi = viewController?.navigationController
        vc.data = data
        viewController?.navigationController?.present(vc, animated: true, completion: nil)
    }
}
