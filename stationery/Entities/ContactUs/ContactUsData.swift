//
//  ContactUsData.swift
//  stationery
//
//  Created by Codigo NOL on 25/06/2021.
//

import Foundation

import ObjectMapper
import RealmSwift

class ContactUsRequest: BaseRequestData {
    
    var fullName : String?
    var email : String?
    var subject : String?
    var message : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        fullName <- map["full-name"]
        email <- map["email"]
        subject <- map["subject"]
        message <- map["message"]
    }
}
