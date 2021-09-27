//  
//  OrderHistoryDetailRouter.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation

@objc protocol OrderHistoryDetailRoutingLogic {
	// func routeToSomewhere()
}

class OrderHistoryDetailRouter: NSObject, OrderHistoryDetailRoutingLogic {
    
    weak var viewController: OrderHistoryDetailVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
