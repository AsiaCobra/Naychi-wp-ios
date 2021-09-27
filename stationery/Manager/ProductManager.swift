//
//  ProductManager.swift
//  stationery
//
//  Created by Codigo NOL on 21/12/2020.
//

import Foundation

class ProductManager {
    static let shared = ProductManager()

    func getCatagories(request: ProductCategoryRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Categories, parameters: request.toJSON(), completed: completion)
    }
    
    func getProducts(request: ProductRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Products, parameters: request.toJSON(), completed: completion)
    }
    
    func getProducts(arg: Args?, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Products, parameters: arg?.toJSON(), completed: completion)
    }
    
    
    func getProductById(id: String, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.ProductById(id), parameters: nil, completed: completion)
    }
    
    func getProductReviews(request: ReviewRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Reviews, parameters: request.toJSON(), completed: completion)
    }
    
    func submitReview(request: ReviewSubmitRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .post, path: EndPoints.Reviews, parameters: request.toJSON(), completed: completion)
    }
    
    func getBrands(request: BrandRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Brands, parameters: request.toJSON(), completed: completion)
    }
    
    func getBrands(arg: Args?, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Brands, parameters: arg?.toJSON(), completed: completion)
    }
    
}
