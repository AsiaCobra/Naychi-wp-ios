//
//  ProductCategory.swift
//  stationery
//
//  Created by Codigo NOL on 21/12/2020.
//

import Foundation
import ObjectMapper
import RealmSwift


class ProductCategoryRequest: BaseRequestData {
    var page: Int = 1
    var per_page: Int = 100
    var parent: Int = 0
    var hideEmpty: Bool = true
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        page <- map["page"]
        per_page <- map["per_page"]
        parent <- map["parent"]
        hideEmpty <- map["hide_empty"]
    }
}

class ProductCategory: Object, Mappable {
    @objc dynamic var links: Link?
    let count = RealmOptional<Int>()
    @objc dynamic var descriptionField:  String?
    @objc dynamic var display:  String?
    @objc dynamic var id: Int = 0
    @objc dynamic var image: Image?
    @objc dynamic var menuOrder: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var nameMm: String?
    let parent = RealmOptional<Int>()
    @objc dynamic var slug: String?

    required convenience init?(map: Map) { self.init() }
    
    public override class func primaryKey() -> String? { return "id" }

    func mapping(map: Map) {
        links <- map["_links"]
        count.value <- map["count"]
        descriptionField <- map["description"]
        display <- map["display"]
        id <- map["id"]
        image <- map["image"]
        menuOrder <- map["menu_order"]
        name <- map["name"]
        parent.value <- map["parent"]
        slug <- map["slug"]
        
        name = name?.htmlToString
    }
}
