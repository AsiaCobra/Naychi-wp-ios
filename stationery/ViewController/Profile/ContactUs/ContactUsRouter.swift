//  
//  ContactUsRouter.swift
//  stationery
//
//  Created by Codigo NOL on 16/01/2021.
//

import Foundation

@objc protocol ContactUsRoutingLogic {
	// func routeToSomewhere()
}

class ContactUsRouter: NSObject, ContactUsRoutingLogic {
    
    weak var viewController: ContactUsVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
