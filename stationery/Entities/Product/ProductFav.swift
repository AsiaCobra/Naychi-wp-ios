//
//  ProductFav.swift
//  stationery
//
//  Created by Codigo NOL on 03/01/2021.
//

import Foundation
import ObjectMapper
import RealmSwift

public class ProductFav: Object {
    
    @objc dynamic var links : Link?
    @objc dynamic var averageRating : String?
    let backordered = RealmOptional<Bool>()
    @objc dynamic var backorders : String?
    let backordersAllowed = RealmOptional<Bool>()
    @objc dynamic var buttonText : String?
    @objc dynamic var catalogVisibility : String?
    var categories = List<Category>()
    @objc dynamic var dateCreated : String?
    @objc dynamic var dateCreatedGmt : String?
    @objc dynamic var dateModified : String?
    @objc dynamic var dateModifiedGmt : String?
    @objc dynamic var descriptionField : String?
//    var dimensions : Dimension?
//    var downloadExpiry : Int?
//    var downloadLimit : Int?
//    var downloadable : Bool?
//    var externalUrl : String?
    let featured = RealmOptional<Bool>()
    
    @objc dynamic public var id = "0"
    var images = List<Image>()
    let manageStock = RealmOptional<Bool>()
    let menuOrder = RealmOptional<Int>()
    @objc dynamic var name : String?
    let onSale = RealmOptional<Bool>()
    let parentId = RealmOptional<Int>()
    @objc dynamic var permalink : String?
    let price = RealmOptional<Int>()
    @objc dynamic var priceHtml : String?
    let purchasable = RealmOptional<Bool>()
    @objc dynamic var purchaseNote : String?
    let ratingCount = RealmOptional<Int>()
    let regularPrice = RealmOptional<Int>()
    var relatedIds = List<Int>()
    let reviewsAllowed = RealmOptional<Bool>()
    @objc dynamic var salePrice : String?
    @objc dynamic var shippingClass : String?
    let shippingClassId = RealmOptional<Int>()
    let shippingRequired = RealmOptional<Bool>()
    let shippingTaxable = RealmOptional<Bool>()
    @objc dynamic var shortDescription : String?
    @objc dynamic var sku : String?
    @objc dynamic var slug : String?
    let soldIndividually = RealmOptional<Bool>()
    @objc dynamic var status : String?
    @objc dynamic var stockStatus : String?
    @objc dynamic var taxClass : String?
    @objc dynamic var taxStatus : String?
    let totalSales = RealmOptional<Int>()
    @objc dynamic var type : String?
    let virtual = RealmOptional<Bool>()
    @objc dynamic var weight : String?
    
    @objc dynamic var priceNormal: Int = 0
    @objc dynamic var priceEng: String?
    @objc dynamic var priceMm: String?
    @objc dynamic var priceRegular: Int = 0
    @objc dynamic var priceRegularEng: String?
    @objc dynamic var priceRegularMm: String?
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    func setData(data: ProductResponse) {
        links = data.links
        averageRating = data.averageRating
        backordered.value = data.backordered
        backorders = data.backorders
        backordersAllowed.value = data.backordersAllowed
        buttonText = data.buttonText
        catalogVisibility = data.catalogVisibility
        data.categories?.forEach { categories.append($0) }
        dateCreated = data.dateCreated
        dateCreatedGmt = data.dateCreatedGmt
        dateModified = data.dateModified
        dateModifiedGmt = data.dateModifiedGmt
        descriptionField = data.descriptionField
//        dimensions : Dimension?
//        downloadExpiry : Int?
//        downloadLimit : Int?
//        downloadable : Bool?
//        externalUrl : String?
        featured.value = data.featured
        id = "\(data.id ?? 0)"
        data.images?.forEach { images.append($0) }
        manageStock.value = data.manageStock
        menuOrder.value = data.menuOrder
        name = data.name
        onSale.value = data.onSale
        parentId.value = data.parentId
        permalink = data.permalink
        price.value = data.price == nil ? data.priceString?.toInt : data.price
        priceHtml = data.priceHtml
        purchasable.value = data.purchasable
        purchaseNote = data.purchaseNote
        ratingCount.value = data.ratingCount
        regularPrice.value = data.regularPrice == nil ? data.regularPriceString?.toInt : data.regularPrice
        data.relatedIds?.forEach { relatedIds.append($0) }
        reviewsAllowed.value = data.reviewsAllowed
        salePrice = data.salePrice
        shippingClass = data.shippingClass
        shippingClassId.value = data.shippingClassId
        shippingRequired.value = data.shippingRequired
        shippingTaxable.value = data.shippingTaxable
        shortDescription = data.shortDescription
        sku = data.sku
        slug = data.slug
        soldIndividually.value = data.soldIndividually
        status = data.status
        stockStatus = data.stockStatus
        taxClass = data.taxClass
        taxStatus = data.taxStatus
        totalSales.value = data.totalSales
        type = data.type
        virtual.value = data.virtual
        weight = data.weight
        
        priceNormal = data.priceNormal ?? 0
        priceEng = data.priceEng
        priceMm = data.priceMm
        priceRegular = data.priceRegular ?? 0
        priceRegularEng = data.priceRegularEng
        priceRegularMm = data.priceRegularMm
    }
    
    func toProductResponse() -> ProductResponse {
        let data = ProductResponse()
        data.links = links
        data.averageRating = averageRating
        data.backordered = backordered.value
        data.backorders = backorders
        data.backordersAllowed = backordersAllowed.value
        data.buttonText = buttonText
        data.catalogVisibility = catalogVisibility
        data.categories = []
        categories.forEach { data.categories?.append($0) }
        data.dateCreated = dateCreated
        data.dateCreatedGmt = dateCreatedGmt
        data.dateModified = dateModified
        data.dateModifiedGmt = dateModifiedGmt
        data.descriptionField = descriptionField
//        dimensions : Dimension?
//        downloadExpiry : Int?
//        downloadLimit : Int?
//        downloadable : Bool?
//        externalUrl : String?
        data.featured = featured.value
        data.id = id.toInt
        data.images = []
        images.forEach { data.images?.append($0) }
        data.manageStock = manageStock.value
        data.menuOrder = menuOrder.value
        data.name = name
        data.onSale = onSale.value
        data.parentId = parentId.value
        data.permalink = permalink
        data.price = price.value
        data.priceHtml = priceHtml
        data.purchasable = purchasable.value
        data.purchaseNote = purchaseNote
        data.ratingCount = ratingCount.value
        data.regularPrice = regularPrice.value
        data.relatedIds = []
        relatedIds.forEach { data.relatedIds?.append($0) }
        data.reviewsAllowed = reviewsAllowed.value
        data.salePrice = salePrice
        data.shippingClass = shippingClass
        data.shippingClassId = shippingClassId.value
        data.shippingRequired = shippingRequired.value
        data.shippingTaxable = shippingTaxable.value
        data.shortDescription = shortDescription
        data.sku = sku
        data.slug = slug
        data.soldIndividually = soldIndividually.value
        data.status = status
        data.stockStatus = stockStatus
        data.taxClass = taxClass
        data.taxStatus = taxStatus
        data.totalSales = totalSales.value
        data.type = type
        data.virtual = virtual.value
        data.weight = weight
        data.quantity = 1
        
        data.priceNormal = priceNormal
        data.priceEng = priceEng
        data.priceMm = priceMm
        data.priceRegular = priceRegular
        data.priceRegularEng = priceRegularEng
        data.priceRegularMm = priceRegularMm
        
        return data
    }
}
