//  
//  ProfileWorker.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation
import ObjectMapper

class ProfileWorker {
    func createCustomer(request: CustomerRequest, completion: @escaping (_ response: CustomerResponse?, _ errorMessage: String?) -> Void) {
        
        CustomerManager.shared.create(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<CustomerResponse>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getCustomer(request: CustomerRequest, completion: @escaping (_ response: [CustomerResponse]?, _ errorMessage: String?) -> Void) {
        
        CustomerManager.shared.get(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<CustomerResponse>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
