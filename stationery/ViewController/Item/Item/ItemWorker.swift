//  
//  ItemWorker.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import Foundation
import ObjectMapper

class ItemWorker {
    func getProduct(request: ProductRequest, completion: @escaping (_ response: [ProductResponse]?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getProducts(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<ProductResponse>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getProduct(arg: Args?, completion: @escaping (_ response: [ProductResponse]?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getProducts(arg: arg, completion: { (apiResponseHandler, _) in
            if let result = Mapper<ProductResponse>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getBrands(request: BrandRequest, completion: @escaping (_ response: [Brand]?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getBrands(request: request, completion: { (apiResponseHandler, _) in
            if let result = Mapper<Brand>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
    
    func getBrands(arg: Args?, completion: @escaping (_ response: [Brand]?, _ errorMessage: String?) -> Void) {
        ProductManager.shared.getBrands(arg: arg, completion: { (apiResponseHandler, _) in
            if let result = Mapper<Brand>().mapArray(JSONObject: apiResponseHandler.data?.rawValue) {
                completion(result, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
