//
//  OrderManager.swift
//  stationery
//
//  Created by Codigo NOL on 10/01/2021.
//

import Foundation

class OrderManager {
    static let shared = OrderManager()

    func getPaymentType(completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.PaymentType, parameters: nil, completed: completion)
    }
    
    func createOrder(request: OrderRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .post, path: EndPoints.CreateOrder, parameters: request.toJSON(), completed: completion)
    }
    
    func getOrders(request: OrderHistoryRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Orders, parameters: request.toJSON(), completed: completion)
    }
}

