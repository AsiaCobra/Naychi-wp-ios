//
//  AppInfo.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation
import ObjectMapper
import RealmSwift

enum HomeSectionType: String {
    case banner = "banner"
    case brand = "brand"
    case category = "category"
    case items = "items"
    case none = "none"
}

class AppInfo: Object, Mappable {
    @objc dynamic var id: String = "0"
    @objc dynamic var website: String?
    var phoneNo = List<String>()
    @objc dynamic var fbPage: String?
    @objc dynamic var email: String?
    @objc dynamic var music: String?
    @objc dynamic var english: AppData?
    @objc dynamic var myanmar: AppData?
    
    var homeBlocks: [HomeSection]?
    var banners: [String]?
    var adsBanners: [String]?
    var menu: [HomeMenu]?
    var groupPrice: GroupPrice?
    var groupTownship: GroupTownship?
    var discountRules: DiscountRule?
    var consumer_key: String?
    var consumer_secret: String?
    var noti: HomeNoti?
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        var phones: [String] = []
        
        website <- map["website"]
        phones <- map["phoneNo"]
        fbPage <- map["fbPage"]
        email <- map["email"]
        english <- map["en"]
        myanmar <- map["mm"]
        music <- map["mp3"]
        homeBlocks <- map["home_blocks"]
        banners <- map["banners"]
        adsBanners <- map["ads_banners"]
        menu <- map["dynamic_menu"]
        groupPrice <- map["group_price"]
        groupTownship <- map["group_township"]
        discountRules <- map["discount_rules"]
        consumer_key <- map["consumer_key"]
        consumer_secret <- map["consumer_secret"]
        noti <- map["noti"]
        
        phones.forEach { phoneNo.append($0) }
    }
}

class AppData: Object, Mappable {
    @objc dynamic var address: String?
    @objc dynamic var openingTime: String?
    @objc dynamic var about: String?
    @objc dynamic var paymentLink: String?
    @objc dynamic var shippingLink: String?
    @objc dynamic var privacyLink: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        address <- map["address"]
        openingTime <- map["openingTime"]
        about <- map["about"]
        paymentLink <- map["paymentLink"]
        shippingLink <- map["shippingLink"]
        privacyLink <- map["privacyLink"]
    }
}

class HomeSection: Mappable {
    var titleMm: String?
    var titleEng: String?
    var args: Args?
    var type: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        titleMm <- map["title_mm"]
        titleEng <- map["title_eng"]
        args <- map["args"]
        type <- map["type"]
    }
}

class Args: ProductRequest {
    
    var taxonomy: String?
    var hide_empty: Bool?
    var fields: String?
    var product: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        taxonomy <- map["taxonomy"]
        hide_empty <- map["hide_empty"]
        fields <- map["fields"]
        parent <- map["parent"]
        product <- map["product"]
    }
}

class HomeMenu: Mappable {
    var titleMm: String?
    var titleEng: String?
    var link: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        titleMm <- map["title_mm"]
        titleEng <- map["title_eng"]
        link <- map["link"]
    }
}

class GroupPrice: Mappable {
    typealias Item = (id: String, value: Int)
    var items: [Item] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        let rawDictionary = map.JSON
        let items = rawDictionary.compactMap { (key, value) -> Item? in
            guard let intValue = value as? Int else { return nil }
            return (key, intValue)
        }
        self.items = items
    }
}

class GroupTownship: Mappable {
    typealias Item = (id: String, value: [[String]])
    var items: [Item] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        let rawDictionary = map.JSON
        let items = rawDictionary.compactMap { (key, value) -> Item? in
            guard let intValue = value as? [[String]] else { return nil }
            return (key, intValue)
        }
        self.items = items
    }
}

class DiscountRule: Mappable {
    typealias Item = (id: String, value: Discount)
    var items: [Item] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        let rawDictionary = map.JSON
        let items = rawDictionary.compactMap { (key, value) -> Item? in
            guard let dis = value as? Dictionary<String, Any>,
                  let discount = Mapper<Discount>().map(JSON: dis) else { return nil }
            return (key, discount)
        }
        self.items = items
    }
}

class Discount: Mappable {
    
    var discountEndDate: String?
    var discountEndTime: String?
    var discountRanges: [DiscountRange]?
    var discountStartDate: String?
    var discountStartTime: String?
    var listDate: String?
    var listId: Int?
    var listName: String?
    var name: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        discountEndDate <- map["discount_end_date"]
        discountEndTime <- map["discount_end_time"]
        discountRanges <- map["discount_quantityranges"]
        discountStartDate <- map["discount_start_date"]
        discountStartTime <- map["discount_start_time"]
        listDate <- map["list_date"]
        listId <- map["list_id"]
        listName <- map["list_name"]
        name <- map["name"]
    }
}

class DiscountRange: Mappable {
    
    var disType: String = ""
    var disValue: String = ""
    var endRange: String = ""
    var startRange: String = ""
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        disType <- map["dis_type"]
        disValue <- map["dis_value"]
        endRange <- map["end_range"]
        startRange <- map["start_range"]
    }
}

class HomeNoti: Mappable {
    var status: String?
    var textEng: String?
    var textMm: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        status <- map["status"]
        textEng <- map["text_en"]
        textMm <- map["text_mm"]
    }
}
