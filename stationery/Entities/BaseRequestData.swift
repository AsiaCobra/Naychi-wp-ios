//
//  BaseRequestData.swift
//  stationery
//
//  Created by Codigo NOL on 23/06/2021.
//

import Foundation
import ObjectMapper

class BaseRequestData: Mappable {
//    var consumerKey: String = Constant.ApiCreditial.key
//    var consumerSecret: String = Constant.ApiCreditial.secret
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
//        consumerKey <- map["consumer_key"]
//        consumerSecret <- map["consumer_secret"]
    }
}
