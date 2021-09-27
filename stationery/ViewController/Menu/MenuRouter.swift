//  
//  MenuRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

@objc protocol MenuRoutingLogic {
	// func routeToSomewhere()
}

class MenuRouter: NSObject, MenuRoutingLogic {
    
    weak var viewController: MenuVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
