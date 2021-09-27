//  
//  SplashWorker.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation
import ObjectMapper

class SplashWorker {
    func getProductCatagories(request: ProductCategoryRequest, completion: @escaping (_ response: [ProductCategory]?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getCatagories(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<ProductCategory>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getPaymentType(completion: @escaping (_ response: [PaymentType]?, _ errorMessage: String?) -> Void) {
        OrderManager.shared.getPaymentType(completion: { (apiResponseHandler, _) in
            if let result = Mapper<PaymentType>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getAppInfo(completion: @escaping (_ response: AppInfo?, _ errorMessage: String?) -> Void) {
        AppManager.shared.getAppInfo(completion: { (apiResponseHandler, _) in
            if let result = Mapper<AppInfo>().map(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
