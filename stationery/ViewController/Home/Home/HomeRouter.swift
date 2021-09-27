//  
//  HomeRouter.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol HomeRoutingLogic {
    func routeToDetail(heroIdImage: String, data: ProductResponse)
    func routeToCart()
    func routeToCheckOut()
    func routToProducts(args: Args?, title: String)
    func routeToSearch(catId: String?)
    func routeToCategories(args: Args?)
    func routeToBrands(args: Args?)
    func routeToBrandItems(brand: Brand)
}

class HomeRouter: NSObject, HomeRoutingLogic {
    
    weak var viewController: HomeVC?
    
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
    
    func routToProducts(args: Args?, title: String) {
        let vc = HomeProductVC.instantiate()
        vc.args = args
        vc.navTitle = title
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToSearch(catId: String?) {
        let vc = ItemSearchVC.instantiate()
        vc.selectCatId = catId
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToCategories(args: Args?) {
        viewController?.navigationController?.pushViewController(CategoryVC.instantiate(), animated: true)
    }
    
    func routeToBrands(args: Args?) {
        let vc = BrandVC.instantiate()
        vc.args = args
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToBrandItems(brand: Brand) {
        let vc = BrandItemVC.instantiate()
        vc.brand = brand
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
