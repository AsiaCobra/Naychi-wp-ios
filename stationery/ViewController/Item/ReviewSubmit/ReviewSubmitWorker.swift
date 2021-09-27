//  
//  ReviewSubmitWorker.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import Foundation
import ObjectMapper

class ReviewSubmitWorker {
    
    func submitReview(request: ReviewSubmitRequest, completion: @escaping (_ response: ReviewResponse?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.submitReview(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<ReviewResponse>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
