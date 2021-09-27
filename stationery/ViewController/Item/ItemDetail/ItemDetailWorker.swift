//  
//  ItemDetailWorker.swift
//  stationery
//
//  Created by Codigo NOL on 24/12/2020.
//

import Foundation
import ObjectMapper

class ItemDetailWorker {
    
    func getProduct(id: String, completion: @escaping (_ response: ProductResponse?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getProductById(id: id,  completion: { (apiResponseHandler, _) in
            if let result = Mapper<ProductResponse>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getReviews(request: ReviewRequest, completion: @escaping (_ response: [ReviewResponse]?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getProductReviews(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<ReviewResponse>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
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
