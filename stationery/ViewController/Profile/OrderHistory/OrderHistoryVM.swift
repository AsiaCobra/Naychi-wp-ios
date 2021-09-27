//  
//  OrderHistoryVM.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation

protocol OrderHistoryVMBusinessLogic {
     func getOrders()
}

class OrderHistoryVM: OrderHistoryVMBusinessLogic {

    weak var viewController: OrderHistoryDisplayLogic?
    var worker = OrderHistoryWorker()

    func getOrders() {
        guard let detail = ShopUtil.getBillingDetail(), let customerId = detail.customerId?.toInt else {
            viewController?.didFailOrders()
            return
        }
        
        LoadingView.shared.show()
        
        let request = OrderHistoryRequest()
        request.customer = customerId
        
        worker.getOrders(request: request, completion: { (response, _) in
            LoadingView.shared.hide()
            if let data = response {
                self.viewController?.didSuccessOrders(data: data)
            } else {
                self.viewController?.didFailOrders()
            }
        })
    }
}
