//
//  BrandData.swift
//  stationery
//
//  Created by Codigo NOL on 20/01/2021.
//

import Foundation
import ObjectMapper

class BrandRequest: BaseRequestData {
    var page: Int = 1
    var per_page: Int = 100
    var taxonomy: String?
    var hide_empty: Bool?
    var fields: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        page <- map["page"]
        per_page <- map["per_page"]
        taxonomy <- map["taxonomy"]
        hide_empty <- map["hide_empty"]
        fields <- map["fields"]
    }
}

class Brand: Mappable {
    var links : Link?
    var count : Int?
    var desc : String?
    var display : String?
    var id : Int?
    var image : Image?
    var menuOrder : Int?
    var name : String?
    var parent : Int?
    var slug : String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        links <- map["_links"]
        count <- map["count"]
        desc <- map["description"]
        display <- map["display"]
        id <- map["id"]
        image <- map["image"]
        menuOrder <- map["menu_order"]
        name <- map["name"]
        parent <- map["parent"]
        slug <- map["slug"]

    }
}
