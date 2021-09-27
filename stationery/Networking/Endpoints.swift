//
//  Endpoints.swift
//  Network
//
//  Created by Codigo Kaung Soe on 04/12/2019.
//  Copyright © 2019 codigo. All rights reserved.
//

import Foundation
import Alamofire

public enum EndPoints: URLConvertible {
    
    case Products
    case ProductById(String)
    case Categories
    case PaymentType
    case CreateOrder
    case Orders
    case Customer
    case CustomerUpdate(String)
    case Reviews
    case Brands
    
    var path: String {
        switch self {//https://www.naychistationery.com/wp-json/wc/v3"
        case .Products:
            return "/products"
        case .ProductById(let id):
            return "/products/\(id)"
        case .Categories:
            return "/products/categories"
        case .PaymentType:
            return "/payment_gateways"
        case .CreateOrder:
            return "/orders"
        case .Orders:
            return "/orders"
        case .Customer:
            return "/customers"
        case .CustomerUpdate(let id):
            return "/customers/\(id)"
        case .Reviews:
            return "/products/reviews"
        case .Brands:
            return "/products/brands"
        }
    }
    
    var lastPath: String {
        return self.path.split(separator: "/").map(String.init).last ?? "/"
    }
    
    public func asURL() throws -> URL {
        let endpoint = Constant.ApiDomain.domain + Constant.ApiDomain.path + Constant.ApiDomain.version
        
        let queryItems = [URLQueryItem(name: "consumer_key", value: Constant.ApiCreditial.key),
                          URLQueryItem(name: "consumer_secret", value: Constant.ApiCreditial.secret)]
        
        var urlComps = URLComponents(string: endpoint + path)!
        urlComps.queryItems = queryItems
        
//        let url = try endpoint.asURL()
//        return url.appendingPathComponent(path)
       
        return urlComps.url!
    }
}


public enum EndPointsNew: URLConvertible {
    
    case ContactUs
    case AppInfo
    case CurrentTime
    
    var path: String {
        switch self {//https://www.naychistationery.com/mm/wp-json"
        case .ContactUs:
            return "/contact-form-7/v1/contact-forms/1106/feedback"
        case .AppInfo:
            return "/app/info"
        case .CurrentTime:
            return "/app/current-time"
        }
    }
    
    var lastPath: String {
        return self.path.split(separator: "/").map(String.init).last ?? "/"
    }
    
    public func asURL() throws -> URL {
//        let endpoint = Constant.ApiDomain.domain + "/mm/wp-json"
//        let url = try endpoint.asURL()
//        return url.appendingPathComponent(path)
        
        let endpoint = Constant.ApiDomain.domain + "/wp-json"
        
        var queryItems: [URLQueryItem] = []
        
        if self == .AppInfo {
            queryItems = [URLQueryItem(name: "username", value: Constant.ApiCreditial.username),
                          URLQueryItem(name: "password", value: Constant.ApiCreditial.password)]
        }
        
        var urlComps = URLComponents(string: endpoint + path)!
        urlComps.queryItems = queryItems
        
       
        return urlComps.url!
    }
}


