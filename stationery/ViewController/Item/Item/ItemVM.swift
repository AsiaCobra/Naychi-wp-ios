//  
//  ItemVM.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation

protocol ItemVMBusinessLogic {
    func getProduct()
}

class ItemVM: ItemVMBusinessLogic {
    
    weak var viewController: ItemDisplayLogic?
    var worker = ItemWorker()
    var request = ProductRequest()
    
    var totalPerPage = 20
    var page = 1
    var shouldShowLoading = true
    var sortOrder = ItemSort.normal
    var categoryId: String?
    var price = ItemPrice.pAny
    
    func getProduct() {
        
        request.page = page
        request.per_page = totalPerPage
        request.search = nil
        setSortOrder()
        setPrice()
        request.category = categoryId
        
        if shouldShowLoading { LoadingView.shared.show() }
        worker.getProduct(request: request, completion: { (response, _) in
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
    
    func setPrice() {
        let minMax = price.getMinMax()
        request.minPrice = minMax.min
        request.maxPrice = minMax.max
    }
    
    func setSortOrder() {
        switch sortOrder {
        //order -> asc, desc //orderby -> date, id, include, title, slug, modified, menu_order, price, popularity, rating
        case .normal:
            request.order = nil
            request.orderby = nil
        case .popular:
            request.order = "desc"
            request.orderby = "popularity"
        case .rating:
            request.order = "desc"
            request.orderby = "rating"
        case .latest:
            request.order = "desc"
            request.orderby = "date"
        case .priceLow:
            request.order = "asc"
            request.orderby = "price"
        case .priceHight:
            request.order = "desc"
            request.orderby = "price"
        }
        
    }
    
}
