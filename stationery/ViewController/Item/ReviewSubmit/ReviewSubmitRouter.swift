//  
//  ReviewSubmitRouter.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import Foundation

@objc protocol ReviewSubmitRoutingLogic {
	// func routeToSomewhere()
}

class ReviewSubmitRouter: NSObject, ReviewSubmitRoutingLogic {
    
    weak var viewController: ReviewSubmitVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
