//  
//  OrderHistoryRouter.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation

protocol OrderHistoryRoutingLogic {
	 func routeToDetail(data: OrderHistory)
}

class OrderHistoryRouter: NSObject, OrderHistoryRoutingLogic {
    
    weak var viewController: OrderHistoryVC?
    
    // MARK: routing
    func routeToDetail(data: OrderHistory) {
        let vc = OrderHistoryDetailVC.instantiate()
        vc.data = data
        viewController?.navigationController?.pushViewController(vc, animated: true)
     }
}
