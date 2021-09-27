//
//  CommonData.swift
//  stationery
//
//  Created by Codigo NOL on 21/12/2020.
//

import Foundation
import ObjectMapper
import RealmSwift

class Herf: Object, Mappable {

    @objc dynamic var href : String?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        href <- map["href"]
    }
}

class Link: Object, Mappable {

    var collection : [Herf] = []
    var selff : [Herf] = []
    var up : [Herf] = []
    
    var collections = List<Herf>()
    var selfs = List<Herf>()
    var ups = List<Herf>()
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map)
    {
        collection <- map["collection"]
        selff <- map["self"]
        up <- map["up"]
        
        collection.forEach { collections.append($0) }
        selff.forEach { selfs.append($0) }
        up.forEach { ups.append($0) }
        
    }
}

class Category: Object, Mappable{

    let id = RealmOptional<Int>()
    @objc dynamic var name: String?
    @objc dynamic var slug: String?
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        var i: Int?
        i <- map["id"]
        id.value = i
        name <- map["name"]
        slug <- map["slug"]
        
    }

}

class Image: Object, Mappable{

    @objc dynamic var alt: String?
    @objc dynamic var dateCreated: String?
    @objc dynamic var dateCreatedGmt: String?
    @objc dynamic var dateModified: String?
    @objc dynamic var dateModifiedGmt: String?
    let id = RealmOptional<Int>()
    @objc dynamic var name: String?
    @objc dynamic var src: String?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        var i: Int?
        i <- map["id"]
        id.value = i
        
        alt <- map["alt"]
        dateCreated <- map["date_created"]
        dateCreatedGmt <- map["date_created_gmt"]
        dateModified <- map["date_modified"]
        dateModifiedGmt <- map["date_modified_gmt"]
        name <- map["name"]
        src <- map["src"]
        
    }
}

class BaseItem: Mappable{

    var id: Int?
    var name: String?
    var slug: String?
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        
    }

}

class CurrentTime: Mappable{

    var dateString: String?
    var date: Date?
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        dateString <- map["now"]
        
        date = dateString?.toDate(dateFormat: DateFormat.type2.toString(), setLocalTimeZone: false)
    }

}
