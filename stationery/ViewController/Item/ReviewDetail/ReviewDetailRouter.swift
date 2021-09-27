//  
//  ReviewDetailRouter.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import Foundation

@objc protocol ReviewDetailRoutingLogic {
	// func routeToSomewhere()
}

class ReviewDetailRouter: NSObject, ReviewDetailRoutingLogic {
    
    weak var viewController: ReviewDetailVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
