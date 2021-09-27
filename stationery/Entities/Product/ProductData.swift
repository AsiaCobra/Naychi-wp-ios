//
//  ProductData.swift
//  stationery
//
//  Created by Codigo NOL on 22/12/2020.
//

import Foundation
import ObjectMapper
import RealmSwift

class ProductRequest: BaseRequestData {
    var page: Int = 1
    var per_page: Int = 10
    var search: String?
    var order: String? //asc, desc
    var orderby: String? //date, id, include, title, slug, modified, menu_order, price, popularity, rating.
    var category: String? //for category
    var onSale: Bool?
    var feature: Bool?
    var slug: String?
    var status: String = "publish"
    var minPrice: Int?
    var maxPrice: Int?
    var brand: Int?
    
    var after: String?
    var before: String?
    var exclude: [Int]?
    var include: [Int]?
    var offset: Int?
    var parent: Int?
    var parent_exclude: [Int]?
    var type: String?
    var sku: String?
    var tag: String?
    var shipping_class: String?
    var attribute: String?
    var attribute_term: String?
    var tax_class: String?
    var stock_status: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        page <- map["page"]
        per_page <- map["per_page"]
        search <- map["search"]
        order <- map["order"]
        orderby <- map["orderby"]
        category <- map["category"]
        onSale <- map["on_sale"]
        feature <- map["featured"]
        slug <- map["slug"]
        status <- map["status"]
        minPrice <- map["min_price"]
        maxPrice <- map["max_price"]
        brand <- map["brand"]
        
        after <- map["after"]
        before <- map["before"]
        exclude <- map["exclude"]
        include <- map["include"]
        offset <- map["offset"]
        parent <- map["parent"]
        parent_exclude <- map["parent_exclude"]
        type <- map["type"]
        sku <- map["sku"]
        tag <- map["tag"]
        shipping_class <- map["shipping_class"]
        attribute <- map["attribute"]
        attribute_term <- map["attribute_term"]
        tax_class <- map["tax_class"]
        stock_status <- map["stock_status"]
    }
}

class ProductResponse: Mappable {
    var links : Link?
//    var attributes : [AnyObject]?
    var averageRating : String?
    var backordered : Bool?
    var backorders : String?
    var backordersAllowed : Bool?
    var buttonText : String?
    var catalogVisibility : String?
    var categories : [Category]?
//    var crossSellIds : [AnyObject]?
    var dateCreated : String?
    var dateCreatedGmt : String?
    var dateModified : String?
    var dateModifiedGmt : String?
//    var dateOnSaleFrom : AnyObject?
//    var dateOnSaleFromGmt : AnyObject?
//    var dateOnSaleTo : AnyObject?
//    var dateOnSaleToGmt : AnyObject?
//    var defaultAttributes : [AnyObject]?
    var descriptionField : String?
    var dimensions : Dimension?
    var downloadExpiry : Int?
    var downloadLimit : Int?
    var downloadable : Bool?
//    var downloads : [AnyObject]?
    var externalUrl : String?
    var featured : Bool?
//    var groupedProducts : [AnyObject]?
    var id : Int?
    var images : [Image]?
    var manageStock : Bool?
    var menuOrder : Int?
//    var metaData : [MetaData]?
    var name : String?
    var onSale : Bool?
    var parentId : Int?
    var permalink : String?
    var price : Int?
    var priceString : String?
    var priceHtml : String?
    var purchasable : Bool?
    var purchaseNote : String?
    var ratingCount : Int?
    var regularPrice : Int?
    var regularPriceString : String?
    var relatedIds : [Int]?
    var reviewsAllowed : Bool?
    var salePrice : String?
    var shippingClass : String?
    var shippingClassId : Int?
    var shippingRequired : Bool?
    var shippingTaxable : Bool?
    var shortDescription : String?
    var sku : String?
    var slug : String?
    var soldIndividually : Bool?
    var status : String?
//    var stockQuantity : AnyObject?
    var stockStatus : String?
//    var tags : [AnyObject]?
    var taxClass : String?
    var taxStatus : String?
    var totalSales : Int?
    var type : String?
//    var upsellIds : [AnyObject]?
//    var variations : [AnyObject]?
    var virtual : Bool?
    var weight : String?
    var quantity = 0
    var isFavorite = false
    
    var priceNormal: Int?
    var priceEng: String?
    var priceMm: String?
    var priceRegular: Int?
    var priceRegularEng: String?
    var priceRegularMm: String?
    var brands: [BaseItem]?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map)
    {
        links <- map["_links"]
//        attributes <- map["attributes"]
        averageRating <- map["average_rating"]
        backordered <- map["backordered"]
        backorders <- map["backorders"]
        backordersAllowed <- map["backorders_allowed"]
        buttonText <- map["button_text"]
        catalogVisibility <- map["catalog_visibility"]
        categories <- map["categories"]
//        crossSellIds <- map["cross_sell_ids"]
        dateCreated <- map["date_created"]
        dateCreatedGmt <- map["date_created_gmt"]
        dateModified <- map["date_modified"]
        dateModifiedGmt <- map["date_modified_gmt"]
//        dateOnSaleFrom <- map["date_on_sale_from"]
//        dateOnSaleFromGmt <- map["date_on_sale_from_gmt"]
//        dateOnSaleTo <- map["date_on_sale_to"]
//        dateOnSaleToGmt <- map["date_on_sale_to_gmt"]
//        defaultAttributes <- map["default_attributes"]
        descriptionField <- map["description"]
        dimensions <- map["dimensions"]
        downloadExpiry <- map["download_expiry"]
        downloadLimit <- map["download_limit"]
        downloadable <- map["downloadable"]
//        downloads <- map["downloads"]
        externalUrl <- map["external_url"]
        featured <- map["featured"]
//        groupedProducts <- map["grouped_products"]
        id <- map["id"]
        images <- map["images"]
        manageStock <- map["manage_stock"]
        menuOrder <- map["menu_order"]
//        metaData <- map["meta_data"]
        name <- map["name"]
        onSale <- map["on_sale"]
        parentId <- map["parent_id"]
        permalink <- map["permalink"]
        price <- map["price"]
        priceString <- map["price"]
        priceHtml <- map["price_html"]
        purchasable <- map["purchasable"]
        purchaseNote <- map["purchase_note"]
        ratingCount <- map["rating_count"]
        regularPrice <- map["regular_price"]
        regularPriceString <- map["regular_price"]
        relatedIds <- map["related_ids"]
        reviewsAllowed <- map["reviews_allowed"]
        salePrice <- map["sale_price"]
        shippingClass <- map["shipping_class"]
        shippingClassId <- map["shipping_class_id"]
        shippingRequired <- map["shipping_required"]
        shippingTaxable <- map["shipping_taxable"]
        shortDescription <- map["short_description"]
        sku <- map["sku"]
        slug <- map["slug"]
        soldIndividually <- map["sold_individually"]
        status <- map["status"]
//        stockQuantity <- map["stock_quantity"]
        stockStatus <- map["stock_status"]
//        tags <- map["tags"]
        taxClass <- map["tax_class"]
        taxStatus <- map["tax_status"]
        totalSales <- map["total_sales"]
        type <- map["type"]
//        upsellIds <- map["upsell_ids"]
//        variations <- map["variations"]
        virtual <- map["virtual"]
        weight <- map["weight"]
        brands <- map["brands"]
        
        priceNormal = price
        if priceNormal == nil { priceNormal = priceString?.toInt }
        let currency = priceNormal?.toCurrency() ?? "0"
        priceEng = "\(currency) Ks"
        priceMm = "\(currency.mmNumbers()) ကျပ်"
        priceRegular = regularPrice
        if priceRegular == nil { priceRegular = regularPriceString?.toInt }
        let regular = priceRegular?.toCurrency() ?? "0"
        priceRegularMm = "\(regular) Ks"
        priceRegularEng = "\(regular.mmNumbers()) ကျပ်"
    }
    
}
