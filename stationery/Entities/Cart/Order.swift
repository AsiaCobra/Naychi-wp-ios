//
//  Order.swift
//  stationery
//
//  Created by Codigo NOL on 10/01/2021.
//

import Foundation
import ObjectMapper
import RealmSwift

class OrderRequest: BaseRequestData {
    var billing: Billing?
    var items: [OrderItem]?
    var paymentMethod: String?
    var paymentMethodTitle: String?
    var setPaid: Bool?
    var shipping: Shipping?
    var shippingLines: [ShippingLine]?
    var customer: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        billing <- map["billing"]
        items <- map["line_items"]
        paymentMethod <- map["payment_method"]
        paymentMethodTitle <- map["payment_method_title"]
        setPaid <- map["set_paid"]
        shipping <- map["shipping"]
        shippingLines <- map["shipping_lines"]
        customer <- map["customer_id"]
    }
}

class Billing: Mappable{
    
    var address1: String?
    var address2: String?
    var city: String?
    var country: String = "MM"
    var email: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var postcode: String?
    var state: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        address1 <- map["address_1"]
        address2 <- map["address_2"]
        city <- map["city"]
        country <- map["country"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        phone <- map["phone"]
        postcode <- map["postcode"]
        state <- map["state"]
        
    }
}

class OrderItem: Mappable{
    var productId: Int?
    var quantity: Int?
    var variationId: Int?
    
    var name: String?
    var subtotal: String?
    var total: String?
    var price: Int?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        productId <- map["product_id"]
        quantity <- map["quantity"]
        variationId <- map["variation_id"]
        
        name <- map["name"]
        subtotal <- map["subtotal"]
        total <- map["total"]
        price <- map["price"]
    }
}

class Shipping: Mappable{
    
    var address1: String?
    var address2: String?
    var city: String?
    var country: String?
    var firstName: String?
    var lastName: String?
    var postcode: String?
    var state: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        address1 <- map["address_1"]
        address2 <- map["address_2"]
        city <- map["city"]
        country <- map["country"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        postcode <- map["postcode"]
        state <- map["state"]
    }
}


class ShippingLine: Mappable{
    var methodId: String?
    var methodTitle: String?
    var total: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        methodId <- map["method_id"]
        methodTitle <- map["method_title"]
        total <- map["total"]
        
    }
}

class OrderResponse: Mappable {
    //    var links : Link?
    var billing : Billing?
    var cartHash : String?
    var cartTax : String?
    //    var couponLines : [AnyObject]?
    var createdVia : String?
    var currency : String?
    var customerId : Int?
    var customerIpAddress : String?
    var customerNote : String?
    var customerUserAgent : String?
    //    var dateCompleted : AnyObject?
    //    var dateCompletedGmt : AnyObject?
    var dateCreated : String?
    var dateCreatedGmt : String?
    var dateModified : String?
    var dateModifiedGmt : String?
    var datePaid : String?
    var datePaidGmt : String?
    var discountTax : String?
    var discountTotal : String?
    //    var feeLines : [AnyObject]?
    var id : Int?
    var items : [OrderItem]?
    //    var metaData : [MetaData]?
    var number : String?
    var orderKey : String?
    var parentId : Int?
    var paymentMethod : String?
    var paymentMethodTitle : String?
    var pricesIncludeTax : Bool?
    //    var refunds : [AnyObject]?
    var shipping : Shipping?
    var shippingLines : [ShippingLine]?
    var shippingTax : String?
    var shippingTotal : String?
    var status : String?
    //    var taxLines : [TaxLine]?
    var total : String?
    var totalTax : String?
    var transactionId : String?
    var version : String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
//        links <- map["_links"]
        billing <- map["billing"]
        cartHash <- map["cart_hash"]
        cartTax <- map["cart_tax"]
//        couponLines <- map["coupon_lines"]
        createdVia <- map["created_via"]
        currency <- map["currency"]
//        currencySymbol <- map["currency_symbol"]
        customerId <- map["customer_id"]
        customerIpAddress <- map["customer_ip_address"]
        customerNote <- map["customer_note"]
        customerUserAgent <- map["customer_user_agent"]
//        dateCompleted <- map["date_completed"]
//        dateCompletedGmt <- map["date_completed_gmt"]
        dateCreated <- map["date_created"]
        dateCreatedGmt <- map["date_created_gmt"]
        dateModified <- map["date_modified"]
        dateModifiedGmt <- map["date_modified_gmt"]
        datePaid <- map["date_paid"]
        datePaidGmt <- map["date_paid_gmt"]
        discountTax <- map["discount_tax"]
        discountTotal <- map["discount_total"]
//        feeLines <- map["fee_lines"]
        id <- map["id"]
//        lineItems <- map["line_items"]
//        metaData <- map["meta_data"]
        number <- map["number"]
        orderKey <- map["order_key"]
        parentId <- map["parent_id"]
        paymentMethod <- map["payment_method"]
        paymentMethodTitle <- map["payment_method_title"]
        pricesIncludeTax <- map["prices_include_tax"]
//        refunds <- map["refunds"]
        shipping <- map["shipping"]
        shippingLines <- map["shipping_lines"]
        shippingTax <- map["shipping_tax"]
        shippingTotal <- map["shipping_total"]
        status <- map["status"]
//        taxLines <- map["tax_lines"]
        total <- map["total"]
        totalTax <- map["total_tax"]
        transactionId <- map["transaction_id"]
        version <- map["version"]
        
    }
}

