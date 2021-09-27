//  
//  ItemRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol ItemRoutingLogic {
    func routeToDetail(heroIdImage: String, data: ProductResponse)
    func routeToCart()
    func routeToCheckOut()
}

class ItemRouter: NSObject, ItemRoutingLogic {
    
    weak var viewController: ItemVC?
    
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
