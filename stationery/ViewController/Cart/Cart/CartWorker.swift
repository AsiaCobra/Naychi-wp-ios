//  
//  CartWorker.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation
import ObjectMapper

class CartWorker {
    
    func getCurrentTime(completion: @escaping (_ response: CurrentTime?, _ errorMessage: String?) -> Void) {
        AppManager.shared.getCurrentTime(completion: { (apiResponseHandler, _) in
            if let result = Mapper<CurrentTime>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
}
