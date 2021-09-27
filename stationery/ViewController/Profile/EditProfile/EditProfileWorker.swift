//  
//  EditProfileWorker.swift
//  stationery
//
//  Created by Codigo NOL on 13/01/2021.
//

import Foundation
import ObjectMapper

class EditProfileWorker {
    func update(id: String, request: CustomerRequest, completion: @escaping (_ response: CustomerResponse?, _ errorMessage: String?) -> Void) {
        
        CustomerManager.shared.update(id: id, request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<CustomerResponse>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
