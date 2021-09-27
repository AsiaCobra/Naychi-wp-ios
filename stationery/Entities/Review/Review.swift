//
//  Review.swift
//  stationery
//
//  Created by Codigo NOL on 14/01/2021.
//

import Foundation

import ObjectMapper
import RealmSwift

class ReviewRequest: BaseRequestData {
    var page: Int = 1
    var perPage: Int = 100
    var product: String?
//    var status: String = "all"
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        product <- map["product"]
        page <- map["page"]
        perPage <- map["per_page"]
//        status <- map["status"]
    }
}

class ReviewSubmitRequest: BaseRequestData {
    var productId : String?
    var rating : Int?
    var review : String?
    var reviewer : String?
    var reviewerEmail : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        productId <- map["product_id"]
        rating <- map["rating"]
        review <- map["review"]
        reviewer <- map["reviewer"]
        reviewerEmail <- map["reviewer_email"]
    }
}

class ReviewResponse: Mappable {
    //    var links : Link?
    var dateCreated : String?
    var dateCreatedGmt : String?
    var id : Int?
    var productId : Int?
    var rating : Int?
    var review : String?
    var reviewer : String?
    var reviewerAvatarUrls : AvatarUrl?
    var reviewerEmail : String?
    var status : String?
    var verified : Bool?
    var date: Date?
    var dateString: String?
    var dateStringMm: String?
    var comment: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        //        links <- map["_links"]
        dateCreated <- map["date_created"]
        dateCreatedGmt <- map["date_created_gmt"]
        id <- map["id"]
        productId <- map["product_id"]
        rating <- map["rating"]
        review <- map["review"]
        reviewer <- map["reviewer"]
        reviewerAvatarUrls <- map["reviewer_avatar_urls"]
        reviewerEmail <- map["reviewer_email"]
        status <- map["status"]
        verified <- map["verified"]
        
        comment = review?.htmlToString
        date = dateCreated?.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss", setLocalTimeZone: false)
        let month = date?.toString("MMMM", setLocalTimeZone: false) ?? ""
        let dateNo = date?.toString("d, yyyy", setLocalTimeZone: false) ?? ""
        
        dateString = "\(month) \(dateNo)"
        dateStringMm = "\(month.mmMonth()) \(dateNo.mmNumbers())"
    }
}

class AvatarUrl: Mappable {
    var small : String?
    var medium : String?
    var large : String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        small <- map["24"]
        medium <- map["48"]
        large <- map["96"]
    }
}
