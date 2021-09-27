//
//  CustomerData.swift
//  stationery
//
//  Created by Codigo NOL on 13/01/2021.
//

import Foundation
import ObjectMapper
import RealmSwift

class CustomerRequest: BaseRequestData {
    var billing : Billing?
    var email : String?
    var firstName : String?
    var lastName : String?
    var shipping : Shipping?
    var username : String?
    var password: String? = "NayChi2021"
    var role: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        billing <- map["billing"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        shipping <- map["shipping"]
        username <- map["username"]
        password <- map["password"]
        role <- map["role"]
    }
}

class CustomerResponse: Mappable {
//    var links : Link?
    var avatarUrl : String?
    var billing : Billing?
    var dateCreated : String?
    var dateCreatedGmt : String?
    var dateModified : String?
    var dateModifiedGmt : String?
    var email : String?
    var firstName : String?
    var id : Int?
    var isPayingCustomer : Bool?
    var lastName : String?
//        var metaData : [AnyObject]?
    var role : String?
    var shipping : Shipping?
    var username : String?
    
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
//        links <- map["_links"]
        avatarUrl <- map["avatar_url"]
        billing <- map["billing"]
        dateCreated <- map["date_created"]
        dateCreatedGmt <- map["date_created_gmt"]
        dateModified <- map["date_modified"]
        dateModifiedGmt <- map["date_modified_gmt"]
        email <- map["email"]
        firstName <- map["first_name"]
        id <- map["id"]
        isPayingCustomer <- map["is_paying_customer"]
        lastName <- map["last_name"]
//        metaData <- map["meta_data"]
        role <- map["role"]
        shipping <- map["shipping"]
        username <- map["username"]
        
    }
}
