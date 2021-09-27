//  
//  HomeProductRouter.swift
//  stationery
//
//  Created by Codigo NOL on 06/01/2021.
//

import Foundation

protocol HomeProductRoutingLogic {
    func routeToDetail(heroIdImage: String, data: ProductResponse)
    func routeToCart()
    func routeToCheckOut()
}

class HomeProductRouter: NSObject, HomeProductRoutingLogic {
    
    weak var viewController: HomeProductVC?
    
    // MARK: routing
    func routeToDetail(heroIdImage: String, data: ProductResponse) {
        let vc = ItemDetailVC.instantiate()
        vc.heroIdImage = heroIdImage
        vc.data = data
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToCart() {
        guard let tabBar = AppUtil.getTabBar() else { return }
        viewController?.navigationController?.popToRootViewController(animated: false)
        tabBar.routeTo(screen: .cart)
    }
    
    func routeToCheckOut() {
        viewController?.navigationController?.pushViewController(CartAddressVC.instantiate(), animated: true)
    }
}
