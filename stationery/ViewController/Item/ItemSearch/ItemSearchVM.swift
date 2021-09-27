//  
//  ItemSearchVM.swift
//  stationery
//
//  Created by Codigo NOL on 30/12/2020.
//

import Foundation

protocol ItemSearchVMBusinessLogic {
    // func getData()
}

class ItemSearchVM: ItemSearchVMBusinessLogic {

    weak var viewController: ItemSearchDisplayLogic?
//    var worker = ItemSearchWorker()
    var worker = ItemWorker()
    var request = ProductRequest()
    
    var totalPerPage = 20
    var page = 1
    var shouldShowLoading = true
    
    
    func getProduct(_ search: String, category: String) {
        
        request.page = page
        request.per_page = totalPerPage
        request.search = search.isEmpty ? nil : search
        request.order = "desc"
        request.orderby = category.isEmpty ? "date" : "slug"
        request.category = category.isEmpty ? nil : category
        
        if shouldShowLoading { LoadingView.shared.show() }
        worker.getProduct(request: request, completion: { (response, _) in
            if self.shouldShowLoading { LoadingView.shared.hide() }
            if let response = response {
                self.shouldShowLoading = false
                if self.page <= 1 { self.viewController?.didSuccessGetItems(data: response) }
                else { self.viewController?.didSuccessLoadMore(data: response) }
                    
            } else {
                if self.page <= 1 { self.viewController?.didFailGetItems() }
                else { self.viewController?.didFailLoadMore() }
            }
        })
    }
}
