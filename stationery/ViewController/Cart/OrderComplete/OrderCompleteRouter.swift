//  
//  OrderCompleteRouter.swift
//  stationery
//
//  Created by Codigo NOL on 07/01/2021.
//

import Foundation

@objc protocol OrderCompleteRoutingLogic {
	// func routeToSomewhere()
}

class OrderCompleteRouter: NSObject, OrderCompleteRoutingLogic {
    
    weak var viewController: OrderCompleteVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
