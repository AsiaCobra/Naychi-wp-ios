//
//  CustomerManager.swift
//  stationery
//
//  Created by Codigo NOL on 13/01/2021.
//

import Foundation

class CustomerManager {
    static let shared = CustomerManager()
    
    func create(request: CustomerRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .post, path: EndPoints.Customer, parameters: request.toJSON(), completed: completion)
    }
    
    func get(request: CustomerRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .get, path: EndPoints.Customer, parameters: request.toJSON(), completed: completion)
    }
    
    func update(id: String, request: CustomerRequest, completion: @escaping ResponseCompletionHandler) {
        APIManager.sharedInstance.sendRequest(contentType: .applicationJSON, method: .put, path: EndPoints.CustomerUpdate(id), parameters: request.toJSON(), completed: completion)
    }
}


