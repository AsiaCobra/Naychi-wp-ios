//  
//  CategoryRouter.swift
//  stationery
//
//  Created by Codigo NOL on 06/01/2021.
//

import Foundation

@objc protocol CategoryRoutingLogic {
    func routeToSearch(catId: String?)
}

class CategoryRouter: NSObject, CategoryRoutingLogic {
    
    weak var viewController: CategoryVC?
    
    // MARK: routing
    func routeToSearch(catId: String?) {
        let vc = ItemSearchVC.instantiate()
        vc.selectCatId = catId
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
