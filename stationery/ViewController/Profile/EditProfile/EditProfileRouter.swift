//  
//  EditProfileRouter.swift
//  stationery
//
//  Created by Codigo NOL on 13/01/2021.
//

import Foundation

@objc protocol EditProfileRoutingLogic {
	// func routeToSomewhere()
}

class EditProfileRouter: NSObject, EditProfileRoutingLogic {
    
    weak var viewController: EditProfileVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
