//  
//  ItemDetailRouter.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import Foundation
import DrawerMenu

protocol ItemDetailRoutingLogic {
    func routeToDetail(heroIdImage: String, data: ProductResponse)
    func routeToCart()
    func routeToCheckOut()
    func routeToReviewSubmit()
    func routeToReviewDetail(review: ReviewResponse)
    func routeToReviews()
}

class ItemDetailRouter: NSObject, ItemDetailRoutingLogic {
    
    weak var viewController: ItemDetailVC?
    
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
    
    func routeToReviewSubmit() {
        let vc = ReviewSubmitVC.instantiate()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        vc.productId = "\(viewController?.data?.id ?? 0)"
        vc.delegate = viewController
        viewController?.navigationController?.present(vc, animated: true, completion: nil)
    }

    func routeToReviews() {
        let vc = ReviewsVC.instantiate()
        vc.data = viewController?.reviews ?? []
        vc.navTitle = viewController?.data?.name ?? "Reviews"
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToReviewDetail(review: ReviewResponse) {
        let vc = ReviewDetailVC.instantiate()
        vc.data = review
        vc.navTitle = viewController?.data?.name ?? "Review Detail"
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
