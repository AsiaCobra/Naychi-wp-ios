//  
//  OrderHistoryWorker.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation
import ObjectMapper

class OrderHistoryWorker {
    
    func getOrders(request: OrderHistoryRequest, completion: @escaping (_ response: [OrderHistory]?, _ errorMessage: String?) -> Void) {
        
        OrderManager.shared.getOrders(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<OrderHistory>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
}
