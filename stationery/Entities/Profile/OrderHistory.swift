//
//  OrderHistory.swift
//  stationery
//
//  Created by Codigo NOL on 26/06/2021.
//

import Foundation
import ObjectMapper

enum OrderStatus: String {
    case pending = "pending"
    case processing = "processing"
    case onHold = "on-hold"
    case completed = "completed"
    case cancelled = "cancelled"
    case refunded = "refunded"
    case failed = "failed"
}

class OrderHistoryRequest: BaseRequestData {
    var context: String = "view" // view or edit
    var page: Int = 1
    var per_page: Int = 20
    var order: String = "desc"
    var orderBy: String = "date"
    var status: String? //pending, processing, on-hold, completed, cancelled, refunded, and failed.
    var customer: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        context <- map["context"]
        page <- map["page"]
        per_page <- map["per_page"]
        order <- map["order"]
        orderBy <- map["orderBy"]
        status <- map["status"]
        customer <- map["customer_id"]
    }
}

class OrderHistory: Mappable {
    
    var links: Link?
    var billing: Billing?
//    var cartHash: String?
//    var cartTax: String?
//    var couponLines : [AnyObject]?
//    var createdVia: String?
//    var currency: String?
//    var currencySymbol: String?
    var customerId: Int?
//    var customerIpAddress: String?
//    var customerNote: String?
//    var customerUserAgent: String?
//    var dateCompleted: AnyObject?
//    var dateCompletedGmt: AnyObject?
    var dateCreated: String?
    var dateCreatedGmt: String?
    var dateModified: String?
    var dateModifiedGmt: String?
    var datePaid: AnyObject?
    var datePaidGmt: AnyObject?
    var discountTax: String?
    var discountTotal: String?
//    var feeLines : [AnyObject]?
    var id: Int?
    var lineItems : [OrderItem]?
//    var metaData : [MetaData]?
    var number: String?
    var orderKey: String?
//    var parentId: Int?
    var paymentMethod: String?
    var paymentMethodTitle: String?
//    var pricesIncludeTax: Bool?
//    var refunds : [AnyObject]?
    var shipping: Shipping?
//    var shippingLines : [AnyObject]?
//    var shippingTax: String?
    var shippingTotal: String?
    var status: String?
//    var taxLines : [AnyObject]?
    var total: String?
//    var totalTax: String?
    var transactionId: String?
//    var version: String?
    
    required convenience init?(map: Map) { self.init() }
    
    func mapping(map: Map) {
        links <- map["_links"]
        billing <- map["billing"]
//        cartHash <- map["cart_hash"]
//        cartTax <- map["cart_tax"]
//        couponLines <- map["coupon_lines"]
//        createdVia <- map["created_via"]
//        currency <- map["currency"]
//        currencySymbol <- map["currency_symbol"]
        customerId <- map["customer_id"]
//        customerIpAddress <- map["customer_ip_address"]
//        customerNote <- map["customer_note"]
//        customerUserAgent <- map["customer_user_agent"]
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
        lineItems <- map["line_items"]
//        metaData <- map["meta_data"]
        number <- map["number"]
        orderKey <- map["order_key"]
//        parentId <- map["parent_id"]
        paymentMethod <- map["payment_method"]
        paymentMethodTitle <- map["payment_method_title"]
//        pricesIncludeTax <- map["prices_include_tax"]
//        refunds <- map["refunds"]
        shipping <- map["shipping"]
//        shippingLines <- map["shipping_lines"]
//        shippingTax <- map["shipping_tax"]
        shippingTotal <- map["shipping_total"]
        status <- map["status"]
//        taxLines <- map["tax_lines"]
        total <- map["total"]
//        totalTax <- map["total_tax"]
        transactionId <- map["transaction_id"]
//        version <- map["version"]
        
    }
}
