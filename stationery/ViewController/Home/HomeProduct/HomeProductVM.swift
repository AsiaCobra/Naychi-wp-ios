//  
//  HomeProductVM.swift
//  stationery
//
//  Created by Codigo NOL on 06/01/2021.
//

import Foundation

protocol HomeProductVMBusinessLogic {
    func getProduct(args: Args?)
}

class HomeProductVM: HomeProductVMBusinessLogic {

    weak var viewController: HomeProductDisplayLogic?
    var worker = ItemWorker()
    
    var totalPerPage = 20
    var page = 1
    var shouldShowLoading = true
    
    func getProduct(args: Args?) {
        args?.page = page
        args?.per_page = totalPerPage
        
//        switch type {
//        case .productDiscount: request.onSale = true
//        case .productFeature: request.feature = true
//        case .productNew:
//            request.order = "desc"
//            request.orderby = "date"
//        case .productBestSelling:
//            request.order = "desc"
//            request.orderby = "popularity"
//        case .productOther:
//            request.category = "147"
//        default: break
//        }
        
        if shouldShowLoading { LoadingView.shared.show() }
        worker.getProduct(arg: args, completion: { (response, _) in
            if self.shouldShowLoading { LoadingView.shared.hide() }
            if let response = response {
                self.shouldShowLoading = false
                if self.page <= 1 { self.viewController?.didSuccessGetItems(data: ShopUtil.setFav(response)) }
                else { self.viewController?.didSuccessLoadMore(data: ShopUtil.setFav(response)) }
                    
            } else {
                if self.page <= 1 { self.viewController?.didFailGetItems() }
                else { self.viewController?.didFailLoadMore() }
            }
        })
    }
}
