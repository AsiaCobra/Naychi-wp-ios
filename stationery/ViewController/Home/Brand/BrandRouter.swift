//  
//  BrandRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/01/2021.
//

import Foundation

protocol BrandRoutingLogic {
    func routeToBrandItems(brand: Brand)
}

class BrandRouter: NSObject, BrandRoutingLogic {
    
    weak var viewController: BrandVC?
    
    // MARK: routing
    func routeToBrandItems(brand: Brand) {
        let vc = BrandItemVC.instantiate()
        vc.brand = brand
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
