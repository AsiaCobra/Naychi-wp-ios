//  
//  ReviewsRouter.swift
//  stationery
//
//  Created by Codigo NOL on 15/01/2021.
//

import Foundation

@objc protocol ReviewsRoutingLogic {
	// func routeToSomewhere()
}

class ReviewsRouter: NSObject, ReviewsRoutingLogic {
    
    weak var viewController: ReviewsVC?
    
    // MARK: routing
    // func routeToSomewhere() {}
}
