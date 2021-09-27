//  
//  TabbarRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

@objc protocol TabbarRoutingLogic {
	// func routeToSomewhere()
}

class TabbarRouter: NSObject, TabbarRoutingLogic {
    
    weak var viewController: TabbarVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
