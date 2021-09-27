//  
//  CartOrderWorker.swift
//  stationery
//
//  Created by Codigo NOL on 02/01/2021.
//

import Foundation
import ObjectMapper

class CartOrderWorker {
    
    func createOrder(request: OrderRequest, completion: @escaping (_ response: OrderResponse?, _ errorMessage: String?) -> Void) {
        OrderManager.shared.createOrder(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<OrderResponse>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
